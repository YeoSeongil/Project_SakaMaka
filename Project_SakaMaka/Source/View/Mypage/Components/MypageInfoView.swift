//
//  MypageInfoView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/6/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class MypageInfoView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let profileImageView = UIImageView().then {
        $0.image = .unknownUser
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 50
        $0.tintColor = .Turquoise
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .b3
        $0.backgroundColor = .clear
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp View
    private func setView() {
        backgroundColor = .milkWhite
        layer.cornerRadius = 10
        
        [profileImageView, nameLabel].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        profileImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-10)
            $0.width.height.equalTo(100)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func bind() {
    }
}

extension MypageInfoView {
    func configuration(user: [User]) {
        if user.isEmpty {
            nameLabel.text = ""
        } else {
            nameLabel.text = user[0].name
        }
    }
    
    func setProfile(url: String) {
        if url.isEmpty {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        } else {
            profileImageView.setImageKingfisher(with: url)
        }
    }
}
