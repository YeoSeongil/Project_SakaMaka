//
//  LoginViewModel.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

import RxCocoa
import RxSwift

protocol LoginViewModelType {
    // Input
    var tappedAppleLogin: AnyObserver<Void> { get }
    var tappedGoogleLogin: AnyObserver<Void> { get }
}

class LoginViewModel {
    
    private let disposeBag = DisposeBag()

    private let inputTappedAppleLogin = PublishSubject<Void>()
    private let inputTappedGoogleLogin = PublishSubject<Void>()
    
    init() {
        tryAppleLogin()
        AppleAuthService.shared.delegate = self
    }
    
    private func tryAppleLogin() {
        inputTappedAppleLogin
            .subscribe(with: self) { owner, _ in
                owner.requestAppleAuth()
            }
            .disposed(by: disposeBag)
    }
    
    private func requestAppleAuth() {
        AppleAuthService.shared.signInWithApple()
    }
}

extension LoginViewModel: LoginViewModelType {
    var tappedAppleLogin: AnyObserver<Void> {
        inputTappedAppleLogin.asObserver()
    }
    
    var tappedGoogleLogin: AnyObserver<Void> {
        inputTappedGoogleLogin.asObserver()
    }
}

extension LoginViewModel: AppleAuthServiceDelegate {
    func didSuccessSignInFirebaseWithApple() {
        FireBaseService.shared.checkIsCurrentUserRegistered()
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    debugPrint("#debug: 유저 정보 존재합니다.")
                case .notFindCurrentUser:
                    debugPrint("#debug: 유저 정보가 존재하지 않습니다.")
                }
            })
            .disposed(by: disposeBag)
    }
    
    func didFailedSignInFirebaseWithApple(_ error: Error) {
        // 파이어베이스 로그인 실패
    }
    
    func didFailedAppleLoginHandle(_ error: Error) {
        //
    }
}
