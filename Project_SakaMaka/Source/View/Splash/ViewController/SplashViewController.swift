//
//  SplashViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/18/24.
//

import UIKit

import RxSwift
import RxCocoa

import SnapKit
import Then

class SplashViewController: BaseViewController {
    
    // MARK: - UI Components
    private let titleLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "사카", attributes: [.font: UIFont.h8, .foregroundColor: UIColor.white])
        attributedString.append(NSAttributedString(string: "마카", attributes: [.font: UIFont.h8, .foregroundColor: UIColor.milkWhite]))
        $0.attributedText = attributedString
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        super.setViewController()
        view.backgroundColor = .Turquoise
        [titleLabel].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
