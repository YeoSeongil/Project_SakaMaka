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
