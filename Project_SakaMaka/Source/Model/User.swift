//
//  User.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/21/24.
//

import FirebaseFirestore

struct User: Codable {
    var id: String?  // Firestore 문서 ID를 저장
    var name: String
    var isRegistered: Bool
    
    init(id: String? = nil, name: String, profileImageURL: String, isRegistered: Bool) {
        self.id = id
        self.name = name
        self.isRegistered = isRegistered
    }
}
