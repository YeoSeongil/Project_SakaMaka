//
//  FireBaseService.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

import RxSwift

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
    
    func registerFirebaseUser(nickName: String, image: UIImage) -> Observable<registerFirebaseUserType> {
        return Observable.create { observer in
            if let currentUser = Auth.auth().currentUser {
                let userRef = Firestore.firestore().collection("users").document(currentUser.uid)
                
                let userData: [String: Any] = [
                    "name" : nickName,
                    "isRegistered" : true
                ]
                
                userRef.setData(userData) { error in
                    if let error = error {
                        observer.onNext(.failedRegister)
                    }  else {
                        let storageRef = Storage.storage().reference().child("profiles/\(currentUser.uid)")
                        
                        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
                        
                        storageRef.putData(imageData, metadata: nil) { metadata, error in
                            if let error = error { observer.onNext(.failedUploadImage) }
                            observer.onNext(.success)
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    func postUpload(title: String, image: UIImage, price: String, link: String, content: String) -> Observable<postUploadType> {
        return Observable.create { observer in
            if let currentUser = Auth.auth().currentUser {
                // 이미지 업로드
                guard let imageData = image.jpegData(compressionQuality: 0.5) else { return Disposables.create()  }
                
                let imageName = "\(title)\(UUID().uuidString)"
                let storageRef = Storage.storage().reference().child("postImages/\(imageName)")
                
                storageRef.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        // Handle error
                    } else {
                        // 이미지 다운로드 URL 획득
                        storageRef.downloadURL { url, error in
                            if let error = error {
                                observer.onNext(.handleError)
                            } else if let url = url {
                                // 프로필 이미지 다운로드 URL 획득
                                let profileImageStorageRef = Storage.storage().reference().child("profiles/\(currentUser.uid)")
                                profileImageStorageRef.downloadURL { profileURL, error in
                                    if let error = error {
                                        observer.onNext(.handleError)
                                    } else if let profileURL = profileURL {
                                        // 사용자 이름 가져오기
                                        Firestore.firestore().collection("users").document(currentUser.uid).getDocument { (document, error) in
                                            if let error = error {
                                                observer.onNext(.handleError)
                                            } else if let document = document, document.exists, let userName = document.data()?["name"] as? String {
                                                // 이미지 URL과 함께 포스트 데이터 Firestore에 저장
                                                let postData: [String: Any] = [
                                                    "title": title,
                                                    "imageURL": url.absoluteString,
                                                    "profileURL": profileURL.absoluteString,
                                                    "price": price,
                                                    "link": link,
                                                    "content": content,
                                                    "authorName": userName,
                                                    "authorID": currentUser.uid,
                                                    "timestamp": FieldValue.serverTimestamp()
                                                ]
                                                
                                                Firestore.firestore().collection("posts").addDocument(data: postData) { error in
                                                    if let error = error {
                                                        observer.onNext(.handleError)
                                                    } else {
                                                        observer.onNext(.success)
                                                    }
                                                }
                                            } else {
                                                observer.onNext(.handleError)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}
