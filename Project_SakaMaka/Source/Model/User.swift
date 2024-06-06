//
//  User.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/21/24.
//

import FirebaseFirestore

struct User: Codable {
    var name: String
    var isRegistered: Bool
    
    init(name: String, isRegistered: Bool) {
        self.name = name
        self.isRegistered = isRegistered
    }
}
