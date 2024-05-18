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

class FireBaseService {
    
    static let shared = FireBaseService()
    
    private init() { }
    
    func checkIsCurrentUserRegistered() -> Observable<Bool> {
        return Observable.create { observer in
            if let currentUser = Auth.auth().currentUser {
                Firestore.firestore().collection("users").document(currentUser.uid).getDocument { doc, error in
                    if let doc = doc, doc.exists {
                        observer.onNext(true)
                    } else {
                        observer.onNext(false)
                    }
                }
            }
            return Disposables.create()
        }
    }
}
