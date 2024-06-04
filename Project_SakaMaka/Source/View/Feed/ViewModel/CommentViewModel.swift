import RxCocoa
import RxSwift
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol CommentViewModelType {
    var addCommentButtonTapped: AnyObserver<Void> { get }
    var commentValue: AnyObserver<String> { get }
    var postID: AnyObserver<String> { get }
    var addReplyButtonTapped: AnyObserver<(String, String, String)> { get }
    
    // Output
    var commentsData: Driver<[Comment]> { get }
    var successAddComment: Driver<Void> { get }
    func isCurrentUserAuthor(authorId: String) -> Bool
}

class CommentViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let inputAddCommentButtonTapped = PublishSubject<Void>()
    private let inputCommentValue = PublishSubject<String>()
    private let inputPostID = PublishSubject<String>()
    private let inputAddReplyButtonTapped = PublishSubject<(String, String, String)>()
    
    private let outputCommentsData = BehaviorRelay<[Comment]>(value: [])
    private let outputsuccessAddComment = PublishRelay<Void>()
    
    init() {
        tryAddComment()
        tryFetchComments()
        tryAddReply()
    }
    
    private func tryAddComment() {
        inputAddCommentButtonTapped
            .withLatestFrom(Observable.combineLatest(inputPostID, inputCommentValue))
            .subscribe(with: self, onNext: { owner, data in
                owner.addComment(to: data.0, content: data.1)
            })
            .disposed(by: disposeBag)
    }
    
    private func tryFetchComments() {
        inputPostID
            .subscribe(onNext: { [weak self] postID in
                self?.fetchComments(for: postID)
            })
            .disposed(by: disposeBag)
    }

    private func tryAddReply() {
        inputAddReplyButtonTapped
            .subscribe(with: self, onNext: { owner, data in
                owner.addReply(to: data.0, commentID: data.1, content: data.2)
            })
            .disposed(by: disposeBag)
    }

    private func addComment(to postID: String, content: String) {
        let postRef = Firestore.firestore().collection("posts").document(postID)
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        Firestore.firestore().collection("users").document(currentUser.uid).getDocument { (document, error) in
            guard let document = document, document.exists,
                  let userData = document.data(),
                  let userName = userData["name"] as? String else {
                return
            }
            
            let profileImageStorageRef = Storage.storage().reference().child("profiles/\(currentUser.uid)")
            profileImageStorageRef.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else {
                    return
                }
                
                let commentID = postRef.collection("comments").document().documentID
                let commentData: [String: Any] = [
                    "id": commentID,
                    "content": content,
                    "authorID": currentUser.uid,
                    "authorName": userName,
                    "authorProfileURL": profileImageURL,
                    "postID": postID,
                    "timestamp": FieldValue.serverTimestamp(),
                    "parentID": NSNull()  // 댓글은 parentID가 없음
                ]
                
                postRef.collection("comments").document(commentID).setData(commentData) { error in
                    if let error = error {
                        print("Error adding comment: \(error)")
                    } else {
                        print("Comment added successfully")
                        self.outputsuccessAddComment.accept(())
                        self.fetchComments(for: postID)
                    }
                }
            }
        }
    }

    private func addReply(to postID: String, commentID: String, content: String) {
        let postRef = Firestore.firestore().collection("posts").document(postID)
        let commentRef = postRef.collection("comments").document(commentID)
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        Firestore.firestore().collection("users").document(currentUser.uid).getDocument { (document, error) in
            guard let document = document, document.exists,
                  let userData = document.data(),
                  let userName = userData["name"] as? String else {
                return
            }
            
            let profileImageStorageRef = Storage.storage().reference().child("profiles/\(currentUser.uid)")
            profileImageStorageRef.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else {
                    return
                }
                
                let replyID = commentRef.collection("replies").document().documentID
                let replyData: [String: Any] = [
                    "id": replyID,
                    "content": content,
                    "authorID": currentUser.uid,
                    "authorName": userName,
                    "authorProfileURL": profileImageURL,
                    "postID": postID,
                    "parentID": commentID,
                    "timestamp": FieldValue.serverTimestamp()
                ]
                
                commentRef.collection("replies").document(replyID).setData(replyData) { error in
                    if let error = error {
                        print("Error adding reply: \(error)")
                    } else {
                        print("Reply added successfully")
                        self.fetchComments(for: postID)
                    }
                }
            }
        }
    }
    
    private func fetchComments(for postID: String) {
        let postRef = Firestore.firestore().collection("posts").document(postID)
        
        postRef.collection("comments")
            .order(by: "timestamp")
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error fetching comments: \(error)")
                    return
                }
                
                var fetchedComments: [Comment] = []
                var fetchReplyTasks: [DispatchWorkItem] = []
                
                for document in querySnapshot?.documents ?? [] {
                    let data = document.data()
                    let comment = Comment(document: data)
                    
                    fetchedComments.append(comment)
                    
                    // 대댓글을 가져오는 비동기 작업 추가
                    let fetchReplyTask = DispatchWorkItem {
                        postRef.collection("comments").document(comment.id).collection("replies")
                            .order(by: "timestamp")
                            .getDocuments { (querySnapshot, error) in
                                if let error = error {
                                    print("Error fetching replies: \(error)")
                                    return
                                }
                                
                                var fetchedReplies: [Reply] = []
                                
                                for document in querySnapshot?.documents ?? [] {
                                    let replyData = document.data()
                                    let reply = Reply(document: replyData)
                                    fetchedReplies.append(reply)
                                }
                                
                                // 대댓글을 해당 댓글의 replies에 추가
                                if let index = fetchedComments.firstIndex(where: { $0.id == comment.id }) {
                                    fetchedComments[index].replies = fetchedReplies
                                }
                                
                                // 모든 대댓글이 추가되면 UI를 업데이트
                                self?.outputCommentsData.accept(fetchedComments)
                            }
                    }
                    fetchReplyTasks.append(fetchReplyTask)
                }
                
                // 모든 댓글에 대한 대댓글을 비동기적으로 가져옴
                let queue = DispatchQueue(label: "FetchReplyQueue")
                fetchReplyTasks.forEach { queue.async(execute: $0) }
            }
    }


}

extension CommentViewModel: CommentViewModelType {
    var addCommentButtonTapped: AnyObserver<Void> {
        inputAddCommentButtonTapped.asObserver()
    }
    
    var commentValue: AnyObserver<String> {
        inputCommentValue.asObserver()
    }
    
    var postID: AnyObserver<String> {
        inputPostID.asObserver()
    }
    
    var addReplyButtonTapped: AnyObserver<(String, String, String)> {
        inputAddReplyButtonTapped.asObserver()
    }
    
    var commentsData: Driver<[Comment]> {
        outputCommentsData.asDriver(onErrorDriveWith: .empty())
    }
    
    var successAddComment: Driver<Void> {
        outputsuccessAddComment.asDriver(onErrorDriveWith: .empty())
    }
    
    func isCurrentUserAuthor(authorId: String) -> Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        return authorId == currentUserID
    }
}
