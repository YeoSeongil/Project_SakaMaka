//
//  GoogleAuthService.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/19/24.
//

import FirebaseAuth
import FirebaseCore

import GoogleSignIn

class GoogleAuthService: NSObject {
    
    static let shared = GoogleAuthService()
    
    private override init() { }
    
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // 핸들링 파라미터를 ViewController로 줘야하기 때문에 이걸 어떻게 해야할지 생각을 해봐야할듯..?
        // 굳이 매니저를 작성하지 말고 그냥 뷰컨에서 구현하던지 해야할듯
        // 그렇게 따지면 애플 로그인도 그냥 뷰컨에서 해야할듯? 굳이 MVVM하고 Rx에 목매달지말고 하는게 맞다.
        // 일단 Auth 매니저 삭제할까 말까 생각을 해봐야할듯?
        GIDSignIn.sharedInstance.signIn(withPresenting: ) { [unowned self] result, error  in
            guard error == nil else {
                
            }
            
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        }
    }
}
