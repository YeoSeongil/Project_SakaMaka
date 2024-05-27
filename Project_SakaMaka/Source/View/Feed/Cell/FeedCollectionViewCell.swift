//
//  FeedCollectionViewCell.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/27/24.
//

import UIKit

import SnapKit
import Then

class FeedCollectionViewCell: UICollectionViewCell {
    static let id: String = "FeedCollectionViewCell"
    
    // MARK: - Components
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.backgroundColor = .clear
    }
    
    // Header
    private let cellHeaderView = UIView().then {
        $0.backgroundColor = .blue
    }
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 15
    }

    private let userNameLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
    }
    
    private let postDateLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b7
        $0.textColor = .nightGray
    }
    
    // Main
    private let cellMainView = UIView().then {
        $0.backgroundColor = .red
    }
    
    private let itemImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 10
    }

    private let titleLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .h6
        $0.textColor = .black
    }
    
    private let contentLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
    }
    
    // Footer
    private let cellFooterView = UIView().then {
        $0.backgroundColor = .green
    }
    
    private let voteBuyButton = UIButton().then {
        $0.setImage(UIImage(systemName: "house"), for: .normal)
    }
    
    private let voteDontBuyButton = UIButton().then {
        $0.setImage(UIImage(systemName: "house"), for: .normal)
    }
    
    private let commentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "house"), for: .normal)
    }
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: SetUp Cell
    private func setCell() {
        backgroundColor = .clear
        
        addSubview(stackView)
        
        [cellHeaderView, cellMainView, cellFooterView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [profileImageView, userNameLabel, postDateLabel].forEach {
            cellHeaderView.addSubview($0)
        }        
        
        [itemImageView, titleLabel, contentLabel].forEach {
            cellMainView.addSubview($0)
        }
        
        [voteBuyButton, voteDontBuyButton, commentButton].forEach {
            cellFooterView.addSubview($0)
        }
    }
    
    private func setConstraint() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        // Header
        cellHeaderView.snp.makeConstraints {
            $0.height.equalTo(32)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        postDateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        // Main
        cellMainView.snp.makeConstraints {
            $0.height.equalTo(388)
        }
        
        itemImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(270)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.bottom).offset(15)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
        }

        // Footer
        cellFooterView.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        voteBuyButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.height.width.equalTo(15)
        }        
        
        voteDontBuyButton.snp.makeConstraints {
            $0.leading.equalTo(voteBuyButton.snp.trailing).offset(10)
            $0.height.width.equalTo(15)
        }
        
        commentButton.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.height.width.equalTo(15)
        }
    }
}

extension FeedCollectionViewCell {
    func configuration(_ data: Post) {
        profileImageView.image = .unknownUser
        userNameLabel.text = data.authorName
        itemImageView.image = .unknownUser
        contentLabel.text = data.content
        postDateLabel.text = "\(data.timestamp)"
        titleLabel.text = data.title
    }
}
