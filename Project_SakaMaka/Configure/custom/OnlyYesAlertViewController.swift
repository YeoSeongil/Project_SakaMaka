//
//  OnlyYesAlertViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/21/24.
//

import UIKit

import SnapKit
import Then

enum OnlyYesAlertType {
    case defaultType
    case customType
}

final class OnlyYesAlertViewController: UIViewController {
    
    // MARK: - Properties
    var yesButtonTapAction: (() -> Void)?
    var onlyAlertType: OnlyYesAlertType = .defaultType
    
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
    
    private lazy var yesButton = UIButton(type: .custom).then {
        $0.setTitle("네", for: .normal)
        $0.titleLabel?.font = .h5
        $0.setTitleColor(.white, for: .normal)
        $0.layer.backgroundColor = UIColor.Turquoise.cgColor
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
        if onlyAlertType == .defaultType {
            if let touch = touches.first, touch.view == self.view {
                dismiss(animated: false)
            }
        }
    }
    
    private func setViewController() {
        view.backgroundColor = .black.withAlphaComponent(0.8)
        containerView.backgroundColor = .white
        
        view.addSubview(containerView)
        [messageLabel, yesButton].forEach {
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
            $0.top.equalToSuperview().offset(35)
        }
        
        yesButton.snp.makeConstraints {
            $0.top.equalTo(messageLabel.snp.bottom).offset(25)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}

// MARK: - Methods
extension OnlyYesAlertViewController {
    private func setAddTarget() {
        self.yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
    }
    
    @discardableResult
    func setButtonTitle(_  yesButtonTitle: String) -> Self {
        self.yesButton.setTitle(yesButtonTitle, for: .normal)
        return self
    }
}

// MARK: - @objc
extension OnlyYesAlertViewController {    
    @objc private func yesButtonTapped() {
        onlyAlertType == .defaultType ? dismiss(animated: false) : self.yesButtonTapAction?()
    }
}
