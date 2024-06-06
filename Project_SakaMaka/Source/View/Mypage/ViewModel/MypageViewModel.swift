//
//  MypageViewModel.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/6/24.
//

import RxSwift
import RxCocoa

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

protocol MypageViewModelType {
    
    // Output
    var userInfoData: Driver<[User]> { get }
    var profileURL: Driver<String> { get }
}

class MypageViewModel{
    private let disposeBag = DisposeBag()
    
    private let outputUserInfoData = BehaviorRelay<[User]>(value: [])
    private let outputProfileURL = BehaviorRelay<String>(value: "")
    
    init() {
        tryFetchUserInfo()
        tryFetchProfileURL()
    }
    
    private func tryFetchUserInfo() {
        fetchUserInfo()
    }
    
    private func tryFetchProfileURL() {
        fetchProfileURL()
    }
}

extension MypageViewModel {
    private func fetchUserInfo() {
         guard let uid = Auth.auth().currentUser?.uid else {
             return
         }
         
         Firestore.firestore().collection("users").document(uid).getDocument { [weak self] document, error in
             if let error = error {
                 print("Error fetching user data: \(error)")
             } else if let document = document, document.exists {
                 if let userData = document.data() {
                     do {
                         let jsonData = try JSONSerialization.data(withJSONObject: userData, options: [])
                         let user = try JSONDecoder().decode(User.self, from: jsonData)
                         self?.outputUserInfoData.accept([user])
                         print("User data fetched successfully")
                     } catch let error {
                         print("Error decoding user data: \(error)")
                     }
                 } else {
                     print("Document does not contain data")
                 }
             } else {
                 print("Document does not exist")
             }
         }
     }
    
    private func fetchProfileURL() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let profileImageRef = Storage.storage().reference().child("profiles/\(currentUser.uid)")
        
        profileImageRef.downloadURL { [weak self] url, error in
            if let error = error {
                print("error")
            } else if let urlString = url?.absoluteString{
                self?.outputProfileURL.accept(urlString)
            }
        }
    }
}

extension MypageViewModel: MypageViewModelType {
    var userInfoData: Driver<[User]> {
        outputUserInfoData.asDriver(onErrorDriveWith: .empty())
    }
    
    var profileURL: Driver<String> {
        outputProfileURL.asDriver(onErrorDriveWith: .empty())
    }
}
