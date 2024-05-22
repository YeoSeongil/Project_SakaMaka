//
//  CustomAlertViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/21/24.
//

import UIKit

import SnapKit
import Then

enum CustomAlertType {
    case defaultType
    case customType
}

final class CustomAlertViewController: UIViewController {
    
    // MARK: - Properties
    var leftButtonTapAction: (() -> Void)?
    var rightButtonTapAction: (() -> Void)?
    var customAlertType: CustomAlertType = .defaultType
    
    // MARK: - UI Components
    private let containerView = UIView().then {
        $0.layer.cornerRadius = 15
    }
    
    private let messageLabel = UILabel().then {
        $0.font = .b4
        $0.textColor = .nightGray
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var rightButton = UIButton(type: .custom).then {
        $0.setTitle("네", for: .normal)
        $0.titleLabel?.font = .h5
        $0.setTitleColor(.white, for: .normal)
        $0.layer.backgroundColor = UIColor.Turquoise.cgColor
        $0.layer.cornerRadius = 10
    }
    
    private lazy var leftButton = UIButton(type: .custom).then {
        $0.setTitle("아니오", for: .normal)
        $0.titleLabel?.font = .h5
        $0.setTitleColor(.Turquoise, for: .normal)
        $0.layer.backgroundColor = UIColor.milkWhite.cgColor
        $0.layer.cornerRadius = 10
    }
    
    init(message: String) {
        super.init(nibName: nil, bundle: nil)
        self.messageLabel.text = message
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController()
        setConstraints()
        setAddTarget()
    }
    
    // MARK: - SetUp VC
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if customAlertType == .defaultType {
            if let touch = touches.first, touch.view == self.view {
                dismiss(animated: false)
            }
        }
    }
    
    private func setViewController() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        [messageLabel, rightButton, leftButton].forEach {
            containerView.addSubview($0)
        }
    }
    
    private func setConstraints() {
        containerView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
        }

        messageLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(26)
        }
        
        leftButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(containerView.snp.centerX).offset(-4)
            $0.height.equalTo(44)
            $0.width.equalTo(145)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        rightButton.snp.makeConstraints {
            $0.top.equalTo(leftButton.snp.top)
            $0.trailing.equalToSuperview().inset(16)
            $0.leading.equalTo(containerView.snp.centerX).offset(4)
            $0.height.equalTo(44)
            $0.width.equalTo(145)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Methods
extension CustomAlertViewController {
    private func setAddTarget() {
        self.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
    }
    
    @discardableResult
    func setButtonTitle(_ leftButtonTitle: String, _ rightButtonTitle: String) -> Self {
        self.rightButton.setTitle(rightButtonTitle, for: .normal)
        self.leftButton.setTitle(leftButtonTitle, for: .normal)
        return self
    }
}

// MARK: - @objc
extension CustomAlertViewController {
    @objc private func leftButtonTapped() {
        customAlertType == .defaultType ? dismiss(animated: false) : self.leftButtonTapAction?()
    }
    
    @objc private func rightButtonTapped() {
        self.rightButtonTapAction?()
    }
}
