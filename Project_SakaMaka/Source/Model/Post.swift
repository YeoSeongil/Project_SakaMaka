//
//  Post.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/27/24.
//

import Foundation
import FirebaseFirestore

struct Post {
    let authorID: String
    let authorName: String
    let content: String
    let imageURL: String
    let profileURL: String
    let link: String
    let price: String
    let timestamp: Timestamp
    let title: String
    
    init?(document: [String:Any]) {
        guard let authorID = document["authorID"] as? String,
              let authorName = document["authorName"] as? String,
              let content = document["content"] as? String,
              let imageURL = document["imageURL"] as? String,
              let profileURL = document["profileURL"] as? String,
              let link = document["link"] as? String,
              let price = document["price"] as? String,
              let timestamp = document["timestamp"] as? Timestamp,
              let title = document["title"] as? String else {
            return nil
        }
        self.authorID = authorID
        self.authorName = authorName
        self.content = content
        self.imageURL = imageURL
        self.profileURL = profileURL
        self.link = link
        self.price = price
        self.timestamp = timestamp
        self.title = title
    }
}
