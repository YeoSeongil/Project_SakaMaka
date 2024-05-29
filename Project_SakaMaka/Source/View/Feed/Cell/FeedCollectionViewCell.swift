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
    
    // MARK: - Components
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
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
        $0.numberOfLines = 1
    }
    
    // Footer
    private let cellFooterView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var voteBuyButton = UIButton().then {
        $0.setImage(.like, for: .normal)
        $0.tintColor = .Turquoise
    }
    
    private let voteDontBuyButton = UIButton().then {
        $0.setImage(.unlike, for: .normal)
        $0.tintColor = .Turquoise
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
        
        [cellHeaderView, cellMainView, cellFooterView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [profileImageView, userNameLabel, postDateLabel, setupButton].forEach {
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
            $0.height.equalTo(330)
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

        // Footer
        cellFooterView.snp.makeConstraints {
            $0.height.equalTo(30)
        }
        
        voteBuyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(25)
        }
        
        voteDontBuyButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(voteBuyButton.snp.trailing).offset(10)
            $0.height.width.equalTo(25)
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
    }
}

extension FeedCollectionViewCell {
    func configuration(_ data: Post) {
        profileImageView.setImageKingfisher(with: data.profileURL)
        userNameLabel.text = data.authorName
        itemImageView.setImageKingfisher(with: data.imageURL)
        contentLabel.text = data.content
        postDateLabel.text = formatTimestamp(data.timestamp)
        titleLabel.text = data.title
    }
    
    func setVoteButtonState(isLiked: Bool, isUnliked: Bool) {
        if isLiked {
            voteBuyButton.setImage(UIImage(named: "like-fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            voteDontBuyButton.setImage(UIImage(named: "unlike"), for: .normal)
        } else if isUnliked {
            voteDontBuyButton.setImage(UIImage(named: "unlike-fill")?.withRenderingMode(.alwaysTemplate), for: .normal)
            voteBuyButton.setImage(UIImage(named: "like"), for: .normal)
        } else {
            voteDontBuyButton.setImage(UIImage(named: "unlike"), for: .normal)
            voteBuyButton.setImage(UIImage(named: "like"), for: .normal)
        }
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
