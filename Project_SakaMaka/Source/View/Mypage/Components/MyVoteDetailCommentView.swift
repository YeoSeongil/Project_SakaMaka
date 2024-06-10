//
//  MyVoteDetailCommentView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/10/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then
//
//protocol MyVoteDetailCommentViewDelegate: AnyObject {
//    func didBackbuttonTapped()
//}

class MyVoteDetailCommentView: UIView {
    
    private let disposeBag = DisposeBag()
    //weak var delegate: MyVoteDetailCommentViewDelegate?
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.tintColor = .Turquoise
    }
    
    private let commentLabel = UILabel().then {
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.font = .b6
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
        
         [titleLabel, profileImageView, commentLabel].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.width.height.equalTo(30)
            $0.leading.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview().offset(-10)
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func bind() {
    }
}

extension MyVoteDetailCommentView {
    func configuration(comment: [Comment]) {
        if comment.isEmpty {
            let attributedString = NSMutableAttributedString(string: "댓글", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.black])
            attributedString.append(NSAttributedString(string: " \(comment.count)개", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.Turquoise]))
            titleLabel.attributedText = attributedString
            
            commentLabel.text = "댓글이 없어요."
            
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        } else {
            let attributedString = NSMutableAttributedString(string: "댓글", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.black])
            attributedString.append(NSAttributedString(string: " \(comment.count)개", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.Turquoise]))
            titleLabel.attributedText = attributedString
            
            commentLabel.text = comment[0].content
            
            profileImageView.setImageKingfisher(with: comment[0].authorProfileURL)
        }
    }
}
