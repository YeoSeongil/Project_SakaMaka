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
    
    // Outout
    var resultAppleSign: Driver<AppleAuthServiceType> { get }
}

class LoginViewModel {
    
    private let disposeBag = DisposeBag()

    private let inputTappedAppleLogin = PublishSubject<Void>()
    private let inputTappedGoogleLogin = PublishSubject<Void>()
    
    private let outputAppleSignResult = PublishRelay<AppleAuthServiceType>()
    
    init() {
        tryAppleLogin()
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
            .subscribe(with: self, onNext: { owner, result in
                owner.outputAppleSignResult.accept(result)
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewModel: LoginViewModelType {
    var tappedAppleLogin: AnyObserver<Void> {
        inputTappedAppleLogin.asObserver()
    }
    
    var tappedGoogleLogin: AnyObserver<Void> {
        inputTappedGoogleLogin.asObserver()
    }
    
    var resultAppleSign: Driver<AppleAuthServiceType> {
        outputAppleSignResult.asDriver(onErrorDriveWith: .empty())
    }
}
