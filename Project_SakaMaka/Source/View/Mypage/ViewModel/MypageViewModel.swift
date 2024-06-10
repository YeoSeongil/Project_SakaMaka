//
//  MypageViewModel.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/6/24.
//

import RxSwift
import RxCocoa

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol MypageViewModelType {
    // Input
    var postID: AnyObserver<String> { get }
    
    // Output
    var userInfoData: Driver<[User]> { get }
    var profileURL: Driver<String> { get }
    var postTumbnailURL: Driver<[Thumbnail]> { get }
    var detailPost: Driver<[Post]> { get }
    var detailComment: Driver<[Comment]> { get }
}

class MypageViewModel{
    private let disposeBag = DisposeBag()
    
    private let inputPostID = PublishSubject<String>()
    
    private let outputUserInfoData = BehaviorRelay<[User]>(value: [])
    private let outputProfileURL = BehaviorRelay<String>(value: "")
    private let outputPostTumbnailURL = BehaviorRelay<[Thumbnail]>(value: [])
    private let outputDetailPost = BehaviorRelay<[Post]>(value: [])
    private let outputDetailComment = BehaviorRelay<[Comment]>(value: [])
    
    init() {
        tryFetchUserInfo()
        tryFetchProfileURL()
        tryFetchPostThumnailURL()
        tryFetchDetailPost()
    }
    
    private func tryFetchUserInfo() {
        fetchUserInfo()
    }
    
    private func tryFetchProfileURL() {
        fetchProfileURL()
    }
    
    private func tryFetchPostThumnailURL() {
        fetchPostThumnailURL()
    }
    
    private func tryFetchDetailPost() {
        inputPostID.subscribe(with:self, onNext: { owner, id in
            owner.fetchDetailPost(id: id)
            owner.fetchComments(for: id)
        })
        .disposed(by: disposeBag)
    }
}

extension MypageViewModel {
    private func fetchUserInfo() {
         guard let uid = Auth.auth().currentUser?.uid else {
             return
         }
         
         Firestore.firestore().collection("users").document(uid).getDocument { [weak self] document, error in
             if let error = error {
                 print("Error fetching user data: \(error)")
             } else if let document = document, document.exists {
                 if let userData = document.data() {
                     do {
                         let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
                         let user = try JSONDecoder().decode(User.self, from: jsonData)
                         self?.outputUserInfoData.accept([user])
                     } catch let error {
                         print("Error decoding user data: \(error)")
                     }
                 } else {
                     print("Document does not contain data")
                 }
             } else {
                 print("Document does not exist")
             }
         }
     }
    
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
    
    private func fetchPostThumnailURL() {
        guard let currentUser = Auth.auth().currentUser else {
            print("err")
            return
        }
        
        let uid = currentUser.uid
        
        Firestore.firestore().collection("posts")
            .whereField("authorID", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error  in
            if let error = error {
                print("error")
            } else {
                var imageURLs: [Thumbnail] = []
                for document in querySnapshot!.documents {
                    if let imageURL = document.data()["imageURL"] as? String {
                        let id = document.documentID
                        let thumbnail = Thumbnail(url: imageURL, id: id)
                        imageURLs.append(thumbnail)
                    }
                }
                self?.outputPostTumbnailURL.accept(imageURLs)
            }
        }
    }
    
    private func fetchDetailPost(id: String) {
        Firestore.firestore().collection("posts").document(id).getDocument { [weak self] (document, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            guard let document = document, document.exists, let data = document.data() else {
                print("Document does not exist or no data")
                return
            }
            
            let post = Post(document: data)
            self.outputDetailPost.accept([post])
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
                    self?.outputDetailComment.accept(fetchedComments)
                }
                
                let queue = DispatchQueue(label: "FetchReplyQueue")
                fetchReplyTasks.forEach { queue.async(execute: $0) }
            }
    }
}

extension MypageViewModel: MypageViewModelType {
    var postID: AnyObserver<String> {
        inputPostID.asObserver()
    }
    
    var userInfoData: Driver<[User]> {
        outputUserInfoData.asDriver(onErrorDriveWith: .empty())
    }
    
    var profileURL: Driver<String> {
        outputProfileURL.asDriver(onErrorDriveWith: .empty())
    }
    
    var postTumbnailURL: Driver<[Thumbnail]> {
        outputPostTumbnailURL.asDriver(onErrorDriveWith: .empty())
    }
    
    var detailPost: Driver<[Post]> {
        outputDetailPost.asDriver(onErrorDriveWith: .empty())
    }
    
    var detailComment: Driver<[Comment]> {
        outputDetailComment.asDriver(onErrorDriveWith: .empty())
    }
}
