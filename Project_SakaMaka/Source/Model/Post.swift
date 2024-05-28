//
//  Post.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/27/24.
//

import Foundation
import FirebaseFirestore

struct Post {
    let id: String
    let title: String
    let imageURL: String
    let profileURL: String
    let price: String
    let link: String
    let content: String
    let authorName: String
    let authorID: String
    let timestamp: Timestamp
    var likeVotes: [String]
    var unlikeVotes: [String]

    init(document: [String: Any]) {
        self.id = document["id"] as? String ?? ""
        self.title = document["title"] as? String ?? ""
        self.imageURL = document["imageURL"] as? String ?? ""
        self.profileURL = document["profileURL"] as? String ?? ""
        self.price = document["price"] as? String ?? ""
        self.link = document["link"] as? String ?? ""
        self.content = document["content"] as? String ?? ""
        self.authorName = document["authorName"] as? String ?? ""
        self.authorID = document["authorID"] as? String ?? ""
        self.timestamp = document["timestamp"] as? Timestamp ?? Timestamp()
        self.likeVotes = document["likeVotes"] as? [String] ?? []
        self.unlikeVotes = document["unlikeVotes"] as? [String] ?? []
    }
}

