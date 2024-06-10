//
//  MyVoteDetailContentView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/10/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class MyVoteDetailContentView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let itemImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }
    
    private let titleLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .h4
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private let contentLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
        $0.numberOfLines = 0
        $0.textAlignment = .natural
    }
    
    private let priceLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .lightGray
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp View
    private func setView() {
         [itemImageView, titleLabel, contentLabel, priceLabel].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        itemImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(230)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(itemImageView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

extension MyVoteDetailContentView {
    func configuration(data: [Post]) {
        if data.isEmpty {
            itemImageView.image = nil
            contentLabel.text = "투표 설명이 없습니다."
            titleLabel.text = "타이틀 정보가 없습니다."
            priceLabel.text = "가격 정보가 없습니다."
        } else {
            itemImageView.setImageKingfisher(with: data[0].imageURL)
            contentLabel.text = data[0].content.isEmpty ? "투표 설명이 없습니다." : data[0].content
            titleLabel.text = data[0].title
            priceLabel.text = data[0].price.isEmpty ? "가격 정보가 없습니다." : "가격: \(data[0].price)원"
        }
    }
}
