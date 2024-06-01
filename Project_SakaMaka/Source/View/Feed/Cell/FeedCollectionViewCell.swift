//
//  FeedCollectionViewCell.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/27/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then
import FirebaseFirestore

class FeedCollectionViewCell: UICollectionViewCell {
    static let id: String = "FeedCollectionViewCell"
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Event Handlers
    var onVoteBuyButtonTapped: (() -> Void)?
    var onVoteDontBuyButtonTapped: (() -> Void)?
    var onSetupButtonTapped: (() -> Void)?
    var onLinkButtonTapped: (() -> Void)?
    var onCommentButtonTapped: (() -> Void)?
    
    // MARK: - Components
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.backgroundColor = .clear
    }
    
    // Header
    private let cellHeaderView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
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
    
    private let setupButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis" ), for: .normal)
        $0.tintColor = .black
    }
    
    // Main
    private let cellMainView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let itemImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
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
        $0.numberOfLines = 3
        $0.textAlignment = .natural
    }
    
    private let priceLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .lightGray
    }

    private let linkButton = UIButton().then {
        $0.setImage(UIImage(systemName: "link"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .Turquoise
        $0.layer.cornerRadius = 15
    }
    
    // Footer
    private let cellFooterView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private let voteBuyView = UIView().then {
        $0.backgroundColor = .milkWhite
        $0.layer.cornerRadius = 5
    }
    
    private let voteBuyButton = UIButton().then {
        $0.setImage(.like, for: .normal)
        $0.tintColor = .Turquoise
    }
    
    private let voteBuyLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "10명"
    }
    
    private let voteDontBuyView = UIView().then {
        $0.backgroundColor = .milkWhite
        $0.layer.cornerRadius = 5
    }
    
    private let voteDontBuyButton = UIButton().then {
        $0.setImage(.unlike, for: .normal)
        $0.tintColor = .Turquoise
    }
    
    private let voteDontBuyLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "0명"
    }
    
    private let commentButton = UIButton().then {
        $0.setImage(.comment, for: .normal)
    }

    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
        setConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: SetUp Cell
    private func setCell() {
        backgroundColor = .clear
        
        addSubview(stackView)
        
        [voteBuyButton, voteBuyLabel].forEach {
            voteBuyView.addSubview($0)
        }
        
        [voteDontBuyButton, voteDontBuyLabel].forEach {
            voteDontBuyView.addSubview($0)
        }
        
        [cellHeaderView, cellMainView, cellFooterView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [profileImageView, userNameLabel, postDateLabel, setupButton].forEach {
            cellHeaderView.addSubview($0)
        }        
        
        [itemImageView, titleLabel, contentLabel, priceLabel, linkButton].forEach {
            cellMainView.addSubview($0)
        }
        
        [voteBuyView, voteDontBuyView, commentButton].forEach {
            cellFooterView.addSubview($0)
        }
    }
    
    private func setConstraint() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        // Header
        cellHeaderView.snp.makeConstraints {
            $0.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        postDateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
        }
        
        setupButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.height.equalTo(30)
        }
        
        // Main
        cellMainView.snp.makeConstraints {
            $0.height.equalTo(391)
        }
        
        itemImageView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(287)
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
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        linkButton.snp.makeConstraints {
            $0.bottom.equalTo(itemImageView.snp.bottom).inset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.width.height.equalTo(30)
        }
        
        // Footer
        cellFooterView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        voteBuyView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.width.equalTo(70)
            $0.height.equalTo(25)
        }
        
        voteBuyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(7)
            $0.width.height.equalTo(20)
        }
        
        voteBuyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(voteBuyButton.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
        }
        
        voteDontBuyView.snp.makeConstraints {
            $0.leading.equalTo(voteBuyView.snp.trailing).offset(15)
            $0.width.equalTo(70)
            $0.height.equalTo(25)
        }
        
        voteDontBuyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(7)
            $0.width.height.equalTo(20)
        }
        
        voteDontBuyLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(voteDontBuyButton.snp.trailing).offset(5)
            $0.trailing.equalToSuperview()
        }
        
        commentButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.width.equalTo(25)
        }
    }
    
    private func bind() {
        voteBuyButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.onVoteBuyButtonTapped?()
            }
            .disposed(by: disposeBag)               
        
        voteDontBuyButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.onVoteDontBuyButtonTapped?()
            }
            .disposed(by: disposeBag)
        
        setupButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.onSetupButtonTapped?()
            }
            .disposed(by: disposeBag)
        
        linkButton.rx.tap
            .bind(with:self) { owner, _ in
                owner.onLinkButtonTapped?()
            }
            .disposed(by: disposeBag)
        
        commentButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.onCommentButtonTapped?()
            }
            .disposed(by: disposeBag)
    }
}

extension FeedCollectionViewCell {
    func configuration(_ data: Post) {
        profileImageView.setImageKingfisher(with: data.profileURL)
        userNameLabel.text = data.authorName
        itemImageView.setImageKingfisher(with: data.imageURL)
        contentLabel.text = data.content.isEmpty ? "투표 설명이 없습니다." : data.content
        postDateLabel.text = formatTimestamp(data.timestamp)
        titleLabel.text = data.title
        
        priceLabel.text = data.price.isEmpty ? "가격 정보가 없습니다." : "가격: \(data.price)원"
        linkButton.isHidden = data.link.isEmpty
        
        voteBuyLabel.text = "\(data.likeVotes.count)명"
        voteDontBuyLabel.text = "\(data.unlikeVotes.count)명"
    }
    
    func setVoteButtonState(isLiked: Bool, isUnliked: Bool) {
        let likeImageName = isLiked ? "like-fill" : "like"
        let unlikeImageName = isUnliked ? "unlike-fill" : "unlike"
        
        voteBuyButton.setImage(UIImage(named: likeImageName)?.withRenderingMode(isLiked ? .alwaysTemplate : .automatic), for: .normal)
        voteDontBuyButton.setImage(UIImage(named: unlikeImageName)?.withRenderingMode(isUnliked ? .alwaysTemplate : .automatic), for: .normal)
    }

    
    func setButtonVisibility(isVisible: Bool) {
        setupButton.isHidden = !isVisible
    }
}

extension FeedCollectionViewCell {
    private func formatTimestamp(_ timestamp: Timestamp) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let date = timestamp.dateValue()
        return formatter.string(from: date)
    }
}
