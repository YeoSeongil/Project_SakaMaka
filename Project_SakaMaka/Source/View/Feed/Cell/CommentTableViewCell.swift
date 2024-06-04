//
//  CommentTableViewCell.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/1/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then
import FirebaseFirestore

class CommentTableViewCell: UITableViewCell {
    static let id: String = "CommentTableViewCell"
    
    var showRepliesAction: (() -> Void)?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 17.5
        $0.layer.masksToBounds = true
        $0.image = UIImage(systemName: "person.crop.circle.fill")
        $0.tintColor = .Turquoise
    }
    
    private let userNameLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
    }
    
    private let commentDateLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b7
        $0.textColor = .nightGray
    }
    
    private let setupButton = UIButton().then {
        $0.setImage(UIImage(systemName: "ellipsis" ), for: .normal)
        $0.tintColor = .black
    }
    
    private let commentLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
        $0.numberOfLines = 0
    }
    
    private let replyLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
    }
    
    private let addReplyButton = UIButton().then {
        $0.setTitleColor(.nightGray, for: .normal)
        $0.setTitle("답글달기", for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .b5
    }
    
    private let showReplyButton = UIButton().then {
        $0.setTitleColor(.Turquoise, for: .normal)
        $0.setTitle("답글 1개 보기", for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .h7
    }
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
        setConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp Cell
    private func setCell() {
        backgroundColor = .white
        selectionStyle = .none
        
        [profileImageView, userNameLabel, commentDateLabel, setupButton, commentLabel, addReplyButton, showReplyButton].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setConstraint() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(35)
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(20)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        commentDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(5)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        setupButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        showReplyButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.showRepliesAction?()
            })
            .disposed(by: disposeBag)
    }
}

extension CommentTableViewCell {
    func setButtonVisibility(isVisible: Bool) {
        setupButton.isHidden = !isVisible
    }
    
    func configuration(comment: Comment, isRepliesVisible: Bool) {
        profileImageView.setImageKingfisher(with: comment.authorProfileURL)
        userNameLabel.text = comment.authorName
        commentDateLabel.text = formatTimestamp(comment.timestamp)
        commentLabel.text = comment.content
        
        if comment.replies.isEmpty {
            showReplyButton.isHidden = true
            addReplyButton.snp.remakeConstraints {
                $0.top.equalTo(commentLabel.snp.bottom).offset(5)
                $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
                $0.height.equalTo(16)
                $0.bottom.equalToSuperview().inset(10)
            }
        } else {
            showReplyButton.isHidden = false
            let replyButtonText = isRepliesVisible ? "답글 숨기기" : "답글 \(comment.replies.count)개 보기"
            showReplyButton.setTitle(replyButtonText, for: .normal)
            addReplyButton.snp.remakeConstraints {
                $0.top.equalTo(commentLabel.snp.bottom).offset(5)
                $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
                $0.height.equalTo(16)
            }
            showReplyButton.snp.remakeConstraints {
                $0.top.equalTo(addReplyButton.snp.bottom).offset(5)
                $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
                $0.height.equalTo(16)
                $0.bottom.equalToSuperview().inset(10)
            }
        }
    }
}

extension CommentTableViewCell {
    private func formatTimestamp(_ timestamp: Timestamp) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let date = timestamp.dateValue()
        return formatter.string(from: date)
    }
}
