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
    
    private let commentLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
    }
    
    private let replyLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b6
        $0.textColor = .black
    }
    
    // Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setCell()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SetUp Cell
    private func setCell() {
        backgroundColor = .white
        
        [profileImageView, userNameLabel, commentDateLabel, commentLabel, replyLabel].forEach {
            self.addSubview($0)
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
            $0.leading.equalTo(userNameLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        replyLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(50)
            $0.height.equalTo(50)
        }
    }
    
    private func bind() {
      
    }
}

extension CommentTableViewCell {
    func configuration(comment: Comment) {
        profileImageView.setImageKingfisher(with: comment.authorProfileURL)
        userNameLabel.text = comment.authorName
        commentDateLabel.text = formatTimestamp(comment.timestamp)
        commentLabel.text = comment.content
        
        var repliesText = ""
        for reply in comment.replies {
            repliesText.append(contentsOf: "\(reply.authorName): \(reply.content)\n")
        }
        replyLabel.text = repliesText
    }
}

extension CommentTableViewCell {
    private func formatTimestamp(_ timestamp: Timestamp) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let date = timestamp.dateValue()
        return formatter.string(from: date)
    }
}
