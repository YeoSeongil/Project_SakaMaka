//
//  AuthServiceError.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

enum AuthError: Error {
    case firebaseError(String)
    case appleSignInError(String)
    case googleSignInError(String)
    case unknownError
}
