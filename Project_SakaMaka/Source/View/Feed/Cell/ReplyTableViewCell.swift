//
//  ReplyTableViewCell.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/3/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then
import FirebaseFirestore

class ReplyTableViewCell: UITableViewCell {
    static let id: String = "ReplyTableViewCell"
    
    private let disposeBag = DisposeBag()
    
    var onSetupButtonTapped: (() -> Void)?
    
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
        $0.numberOfLines = 0
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
        
        [profileImageView, userNameLabel, commentDateLabel, setupButton, commentLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    private func setConstraint() {
        profileImageView.snp.makeConstraints {
            $0.width.height.equalTo(35)
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(50)
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
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        setupButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        setupButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.onSetupButtonTapped?()
            })
            .disposed(by: disposeBag)
    }
}

extension ReplyTableViewCell {
    func configuration(reply: Reply) {
           profileImageView.setImageKingfisher(with: reply.authorProfileURL)
           userNameLabel.text = reply.authorName
           commentDateLabel.text = formatTimestamp(reply.timestamp)
           commentLabel.text = reply.content
       }
    
    func setButtonVisibility(isVisible: Bool) {
        setupButton.isHidden = !isVisible
    }
}

extension ReplyTableViewCell {
    private func formatTimestamp(_ timestamp: Timestamp) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let date = timestamp.dateValue()
        return formatter.string(from: date)
    }
}
