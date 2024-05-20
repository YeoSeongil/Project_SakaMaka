//
//  RegisterViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/20/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class RegisterViewController: BaseViewController {

    private let viewModel: RegisterViewModelType
    
    // MARK: - UI Components
    private let directionLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "사카마카", attributes: [.font: UIFont.h2, .foregroundColor: UIColor.Turquoise])
        attributedString.append(NSAttributedString(string: "에서\n사용할 프로필을 설정해주세요.", attributes: [.font: UIFont.h2_2, .foregroundColor: UIColor.black]))
        $0.attributedText = attributedString
        $0.numberOfLines = 2
    }
    
    private let addProfileImageButton = UIButton().then {
        $0.setTitle("Add Profile", for: .normal)
        $0.backgroundColor = .Turquoise
        $0.layer.cornerRadius = 15
    }
    
    private let addNickNameTextField = UITextField().then {
        let paragraphStyle = NSMutableParagraphStyle()
         paragraphStyle.alignment = .center
         $0.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.lightGray, .paragraphStyle: paragraphStyle])
         $0.font = .h5
         $0.textColor = .Turquoise
         $0.textAlignment = .center
         $0.layer.cornerRadius = 10
         $0.layer.borderWidth = 1
         $0.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: - Init
    init(viewModel: RegisterViewModelType = RegisterViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

    // MARK: - SetUp VC
    override func setViewController() {
        super.setViewController()
        
        [directionLabel, addProfileImageButton, addNickNameTextField].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        directionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        addProfileImageButton.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(directionLabel.snp.bottom).offset(100)
        }
        
        addNickNameTextField.snp.makeConstraints {
            $0.top.equalTo(addProfileImageButton.snp.bottom).offset(35)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.height.equalTo(45)
        }
        
    }
}
