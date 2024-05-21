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

    private let viewModel: LoginViewModelType
    
    // MARK: - UI Components
    private let loginButtonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8.0
        $0.backgroundColor = .clear
    }
    
    private let appleLoginButton = UIButton(type: .system).then {
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 10.0
        $0.backgroundColor = .black
        $0.tintColor = .white
    }
    
    private let appleLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "appleLogo")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFill
    }

    // MARK: - Init
    init(viewModel: LoginViewModelType = LoginViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        super.setViewController()
        
        [loginButtonStackView].forEach {
            view.addSubview($0)
        }
        
        [appleLoginButton].forEach {
            loginButtonStackView.addArrangedSubview($0)
        }
        
        appleLoginButton.addSubview(appleLogoImageView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        loginButtonStackView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaInsets).inset(100)
            $0.height.equalTo(60)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        [appleLoginButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(60)
            }
        }
        
        appleLogoImageView.snp.makeConstraints {
            $0.leading.equalTo(appleLoginButton).offset(20)
            $0.centerY.equalTo(appleLoginButton)
            $0.width.height.equalTo(24)
        }
    }
    
    override func bind() {
        super.bind()
        
        // Input
        appleLoginButton.rx.tap
            .bind(to: viewModel.tappedAppleLogin)
            .disposed(by: disposeBag)
        
        // Output
        viewModel.resultAppleSign
            .drive(with: self, onNext: { owner, result in
                switch result {
                case .appleSignSuccessAndFindCurrentUserOnFirebase:
                    let tabBarController = TabBarController()
                    owner.navigationController?.setViewControllers([tabBarController], animated: true)
                case .appleSignSuccessAndNotFindCurrentUserOnFirebase:
                    let viewController = RegisterViewController()
                    owner.navigationController?.pushViewController(viewController, animated: true)
                case .appleSignFailedOnFirebase:
                    let alert = OnlyYesAlertViewController(message: "파이어 베이스 로그인에 실패했어요.").setButtonTitle("확인했어요.")
                    owner.present(alert, animated: false)
                case .appleSignFailed:
                    let alert = OnlyYesAlertViewController(message: "애플 로그인에 실패했어요.").setButtonTitle("확인했어요.")
                    owner.present(alert, animated: false)
                }
            })
            .disposed(by: disposeBag)
    }
}
