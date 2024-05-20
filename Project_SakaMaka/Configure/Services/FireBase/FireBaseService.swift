//
//  FireBaseService.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore

import RxSwift

enum FirebaseError: Error {
    case notFindCurrentUser
    case failedRegister
}

enum AuthResult {
    case success
    case failed
}

class FireBaseService {
    
    static let shared = FireBaseService()
    
    private init() { }
    
    func checkIsCurrentUserRegistered() -> Observable<checkIsCurrentUserRegisteredType> {
        return Observable.create { observer in
            if let currentUser = Auth.auth().currentUser {
                Firestore.firestore().collection("users").document(currentUser.uid).getDocument { doc, error in
                    if let doc = doc, doc.exists {
                        observer.onNext(.findCurrentUser)
                    } else {
                        observer.onNext(.notFindCurrentUser)
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func registerFirebaseUser(nickName: String) -> Observable<registerFirebaseUserType> {
        return Observable.create { observer in
            if let currentUser = Auth.auth().currentUser {
                let userRef = Firestore.firestore().collection("users").document(currentUser.uid)
                
                let userData: [String: Any] = [
                    "name" : nickName,
                    "image" : "imageURL",
                    "isRegistered" : true
                ]
                
                userRef.setData(userData) { error in
                    if let error = error {
                        observer.onNext(.failedRegister)
                    }  else {
                        observer.onNext(.success)
                    }
                }
            }
            return Disposables.create()
        }
    }
}
