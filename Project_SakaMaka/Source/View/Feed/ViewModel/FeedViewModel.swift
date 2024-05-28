//
//  FeedViewModel.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/27/24.
//

import RxCocoa
import RxSwift

import FirebaseAuth
import FirebaseFirestore


protocol FeedViewModelType {
    // Input
    var voteBuyButtonTapped: AnyObserver<(String, String)> { get }
    var voteDontBuyButtonTapped: AnyObserver<(String, String)> { get }
    
    // Output
    var postsData: Driver<[Post]> { get }
    var hasVoted: Driver<Bool> { get }
    
    // Method
    func isCurrentUserLikedPost(postId: String) -> Bool
    func isCurrentUserUnlikedPost(postId: String) -> Bool
}

class FeedViewModel {
    private let disposeBag = DisposeBag()
    
    // Input
    private let inputVoteBuyButtonTapped = PublishSubject<(String, String)>()
    private let inputVoteDontBuyButtonTapped = PublishSubject<(String, String)>()
    private let inputPostId = PublishSubject<String>()
    private let inputPost = PublishSubject<Post>()
    
    // Output
    private let postsOutput = BehaviorRelay<[Post]>(value: [])
    private let votedOutput = BehaviorRelay<Bool>(value: false)
    
    init() {
        likeVote()
        unlikeVote()
        fetchPosts()
    }

    private func likeVote() {
        inputVoteBuyButtonTapped
            .subscribe(onNext: { id, type in
                FireBaseService.shared.vote(postId: id, vote: type)
            })
            .disposed(by: disposeBag)
    }
    
    private func unlikeVote() {
        inputVoteDontBuyButtonTapped
            .subscribe(onNext: { id, type in
                FireBaseService.shared.vote(postId: id, vote: type)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchPosts() {
        Firestore.firestore().collection("posts")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self else { return }
                
                if let error = error {
                    print("error")
                }
                
                guard let documents = snapshot?.documents else {
                    print("no doc")
                    return
                }
                
                let postsArray = documents.compactMap { Post(document: $0.data()) }
                self.postsOutput.accept(postsArray)
            }
    }
}

extension FeedViewModel: FeedViewModelType {
    var voteBuyButtonTapped: AnyObserver<(String, String)> {
        inputVoteBuyButtonTapped.asObserver()
    }
    
    var voteDontBuyButtonTapped: AnyObserver<(String, String)> {
        inputVoteDontBuyButtonTapped.asObserver()
    }
    
    var postId: AnyObserver<String> {
        inputPostId.asObserver()
    }
    
    var postsData: Driver<[Post]> {
        postsOutput.asDriver(onErrorDriveWith: .empty())
    }
    
    var hasVoted: Driver<Bool>{
        votedOutput.asDriver(onErrorDriveWith: .empty())
    }
    
    func isCurrentUserLikedPost(postId: String) -> Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        
        if let post = postsOutput.value.first(where: { $0.id == postId }) {
            return post.likeVotes.contains(currentUserID)
        }
        
        return false
    }

    func isCurrentUserUnlikedPost(postId: String) -> Bool {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            return false
        }
        
        if let post = postsOutput.value.first(where: { $0.id == postId }) {
            return post.unlikeVotes.contains(currentUserID)
        }
        
        return false
    }
}
