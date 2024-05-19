//
//  ServiceType.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/19/24.
//

import FirebaseAuth
import FirebaseFirestore

// MARK: - checkIsCurrentUserRegistered Type
enum checkIsCurrentUserRegisteredType {
    case success
    case notFindCurrentUser
}

enum registerFirebaseUserType {
    case success
    case failedRegister
}


