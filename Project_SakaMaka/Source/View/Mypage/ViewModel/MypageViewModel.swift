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
    var postTumbnailURL: Driver<[Thumbnail]> { get }
}

class MypageViewModel{
    private let disposeBag = DisposeBag()
    
    private let outputUserInfoData = BehaviorRelay<[User]>(value: [])
    private let outputProfileURL = BehaviorRelay<String>(value: "")
    private let outputPostTumbnailURL = BehaviorRelay<[Thumbnail]>(value: [])
    
    init() {
        tryFetchUserInfo()
        tryFetchProfileURL()
        tryFetchPostThumnailURL()
    }
    
    private func tryFetchUserInfo() {
        fetchUserInfo()
    }
    
    private func tryFetchProfileURL() {
        fetchProfileURL()
    }
    
    private func tryFetchPostThumnailURL() {
        fetchPostThumnailURL()
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
    
    private func fetchPostThumnailURL() {
        guard let currentUser = Auth.auth().currentUser else {
            print("err")
            return
        }
        
        let uid = currentUser.uid
        
        Firestore.firestore().collection("posts")
            .whereField("authorID", isEqualTo: uid)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error  in
            if let error = error {
                print("error")
            } else {
                var imageURLs: [Thumbnail] = []
                for document in querySnapshot!.documents {
                    if let imageURL = document.data()["imageURL"] as? String {
                        let id = document.documentID
                        let thumbnail = Thumbnail(url: imageURL, id: id)
                        imageURLs.append(thumbnail)
                    }
                }
                self?.outputPostTumbnailURL.accept(imageURLs)
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
    
    var postTumbnailURL: Driver<[Thumbnail]> {
        outputPostTumbnailURL.asDriver(onErrorDriveWith: .empty())
    }
}
