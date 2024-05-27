//
//  FeedViewModel.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/27/24.
//

import RxCocoa
import RxSwift

import FirebaseFirestore

protocol FeedViewModelType {
    // Output
    var postsData: Driver<[Post]> { get }
}

class FeedViewModel {
    
    private let postsOutput = BehaviorRelay<[Post]>(value: [])
    
    init() {
        fetchPosts()
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
    var postsData: Driver<[Post]> {
        postsOutput.asDriver(onErrorDriveWith: .empty())
    }
}
