//
//  ServiceType.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/19/24.
//

import FirebaseAuth
import FirebaseFirestore

enum AppleAuthServiceType {
    case appleSignFailedOnFirebase
    case appleSignSuccessAndFindCurrentUserOnFirebase
    case appleSignSuccessAndNotFindCurrentUserOnFirebase
    case appleSignFailed
}

// MARK: - checkIsCurrentUserRegistered Type
enum checkIsCurrentUserRegisteredType {
    case findCurrentUser
    case notFindCurrentUser
}

enum registerFirebaseUserType {
    case success
    case failedRegister
    case failedUploadImage
}

