import RxCocoa
import RxSwift
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol CommentViewModelType {
    var addCommentButtonTapped: AnyObserver<Void> { get }
    var addReplyButtonTapped: AnyObserver<Void> { get }
    var commentValue: AnyObserver<String> { get }
    var postID: AnyObserver<String> { get }
    var commentID: AnyObserver<String> { get }
    var replyValue: AnyObserver<String> { get }
    var commentDeleteValue: AnyObserver<(String, String)> { get }
    var replyDeleteValue: AnyObserver<(String, String, String)> { get }
    var replyID: AnyObserver<String> { get }

    // Output
    var commentsData: Driver<[Comment]> { get }
    var successAddComment: Driver<Void> { get }
    var successAddReply: Driver<Void> { get }
    var profileURL: Driver<String> { get }
    func isCurrentUserAuthor(authorId: String) -> Bool
}

class CommentViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let inputAddCommentButtonTapped = PublishSubject<Void>()
    private let inputAddReplyButtonTapped = PublishSubject<Void>()
    private let inputCommentDeleteValue = PublishSubject<(String, String)>()
    private let inputReplyDeleteValue = PublishSubject<(String, String, String)>()
    private let inputCommentValue = PublishSubject<String>()
    private let inputPostID = PublishSubject<String>()
    private let inputCommentID = PublishSubject<String>()
    private let inputReplyValue = PublishSubject<String>()
    private let inputReplyID = PublishSubject<String>()
    
    private let outputCommentsData = BehaviorRelay<[Comment]>(value: [])
    private let outputSuccessAddComment = PublishRelay<Void>()
    private let outputSuccessAddReply = PublishRelay<Void>()
    private let outputProfileURL = BehaviorRelay<String>(value: "")
    
    init() {
        tryFetchProfileURL()
        tryAddComment()
        tryFetchComments()
        tryAddReply()
        tryDeleteComment()
        tryDeleteReply()
    }
    
    private func tryFetchProfileURL() {
        fetchProfileURL()
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
            .withLatestFrom(Observable.combineLatest(inputPostID, inputCommentID, inputReplyValue))
            .subscribe(with: self, onNext: { owner, data in
                owner.addReply(to: data.0, commentID: data.1, content: data.2)
            })
            .disposed(by: disposeBag)
    }
    
    private func tryDeleteComment() {
        inputCommentDeleteValue
            .subscribe(with: self, onNext: { owner, data in
                owner.deleteComment(postID: data.0, commentID: data.1)
            })
            .disposed(by: disposeBag)
    }
    
    private func tryDeleteReply() {
        inputReplyDeleteValue
            .subscribe(with: self, onNext: { owner, data in
                owner.deleteReply(postID: data.0, commentID: data.1, replyID: data.2)
            })
            .disposed(by: disposeBag)
    }
}

extension CommentViewModel {
    private func fetchProfileURL() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let profileImageRef = Storage.storage().reference().child("profiles/\(currentUser.uid)")
        
        profileImageRef.downloadURL { [weak self] url, error in
            if let error = error {
                print("error")
            } else if let urlString = url?.absoluteString{
                self?.outputProfileURL.accept(urlString)
            }
        }
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
                        self.outputSuccessAddComment.accept(())
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
                        self.outputSuccessAddReply.accept(())
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
                
                let dispatchGroup = DispatchGroup()
                
                for document in querySnapshot?.documents ?? [] {
                    let data = document.data()
                    let comment = Comment(document: data)
                    
                    fetchedComments.append(comment)
                    
                    // 대댓글을 가져오는 비동기 작업 추가
                    dispatchGroup.enter()
                    let fetchReplyTask = DispatchWorkItem {
                        postRef.collection("comments").document(comment.id).collection("replies")
                            .order(by: "timestamp")
                            .getDocuments { (querySnapshot, error) in
                                defer {
                                    dispatchGroup.leave()
                                }
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
                            }
                    }
                    fetchReplyTasks.append(fetchReplyTask)
                }
                
                // 모든 댓글에 대한 대댓글을 비동기적으로 가져옴
                dispatchGroup.notify(queue: .main) {
                    // 모든 대댓글이 추가되면 UI를 업데이트
                    self?.outputCommentsData.accept(fetchedComments)
                }
                
                let queue = DispatchQueue(label: "FetchReplyQueue")
                fetchReplyTasks.forEach { queue.async(execute: $0) }
            }
    }


    private func deleteComment(postID: String, commentID: String) {
        let postRef = Firestore.firestore().collection("posts").document(postID)
        postRef.collection("comments").document(commentID).delete { error in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                print("Post successfully deleted")
                self.fetchComments(for: postID)
            }
        }
    }
    
    private func deleteReply(postID: String, commentID: String, replyID: String) {
        let postRef = Firestore.firestore().collection("posts").document(postID)
        let commentRef = postRef.collection("comments").document(commentID)
        commentRef.collection("replies").document(replyID).delete { error in
            if let error = error {
                print("Error deleting post: \(error.localizedDescription)")
            } else {
                print("Post successfully deleted")
                self.fetchComments(for: postID)
            }
        }
    }
}

extension CommentViewModel: CommentViewModelType {
    var addCommentButtonTapped: AnyObserver<Void> {
        inputAddCommentButtonTapped.asObserver()
    }
    
    var addReplyButtonTapped: AnyObserver<Void> {
        inputAddReplyButtonTapped.asObserver()
    }
    
    var commentValue: AnyObserver<String> {
        inputCommentValue.asObserver()
    }
    
    var commentDeleteValue: AnyObserver<(String, String)> {
        inputCommentDeleteValue.asObserver()
    }
    
    var replyDeleteValue: AnyObserver<(String, String, String)> {
        inputReplyDeleteValue.asObserver()
    }
    
    var postID: AnyObserver<String> {
        inputPostID.asObserver()
    }
    
    var commentID: AnyObserver<String> {
        inputCommentID.asObserver()
    }
    
    var replyValue: AnyObserver<String> {
        inputReplyValue.asObserver()
    }
    
    var replyID: AnyObserver<String> {
        inputReplyID.asObserver()
    }
    
    var commentsData: Driver<[Comment]> {
        outputCommentsData.asDriver(onErrorDriveWith: .empty())
    }
    
    var successAddComment: Driver<Void> {
        outputSuccessAddComment.asDriver(onErrorDriveWith: .empty())
    }

    var successAddReply: Driver<Void> {
        outputSuccessAddReply.asDriver(onErrorDriveWith: .empty())
    }
    
    var profileURL: Driver<String> {
        outputProfileURL.asDriver(onErrorDriveWith: .empty())
    }
    
    func isCurrentUserAuthor(authorId: String) -> Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        return authorId == currentUserID
    }
}
