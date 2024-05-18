//
//  LoginViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

import AuthenticationServices

import RxCocoa
import RxSwift

import SnapKit
import Then

class LoginViewController: BaseViewController {

    // MARK: - UI Components
    
    private let loginButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8.0
        $0.backgroundColor = .clear
    }
    
    private let appleLoginButton = UIButton(type: .system).then {
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 10.0
        $0.backgroundColor = .white
    }
    
    private let appleLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "appleLogo")
        $0.contentMode = .scaleAspectFill
    }
    
    private let googleLoginButton = UIButton(type: .system).then {
        $0.setTitle("Google로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 10.0
        $0.backgroundColor = .white
    }
    
    private let googleLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "googleLogo")
        $0.contentMode = .scaleAspectFill
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setViewController() {
        super.setViewController()
        view.backgroundColor = .black
        
        [loginButtonStackView].forEach {
            view.addSubview($0)
        }
        
        [appleLoginButton, googleLoginButton].forEach {
            loginButtonStackView.addArrangedSubview($0)
        }
        
        appleLoginButton.addSubview(appleLogoImageView)
        googleLoginButton.addSubview(googleLogoImageView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        loginButtonStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets).inset(100)
            $0.height.equalTo(128)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        [appleLoginButton, googleLoginButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(60)
            }
        }
        
        appleLogoImageView.snp.makeConstraints {
            $0.leading.equalTo(appleLoginButton).offset(20)
            $0.centerY.equalTo(appleLoginButton)
            $0.width.height.equalTo(24)
        }       
        
        googleLogoImageView.snp.makeConstraints {
            $0.leading.equalTo(googleLoginButton).offset(20)
            $0.centerY.equalTo(googleLoginButton)
            $0.width.height.equalTo(24)
        }
    }

}
