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

protocol MyVoteDetailCommentViewDelegate: AnyObject {
    func didCommentButtonTapped()
}

class MyVoteDetailCommentView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: MyVoteDetailCommentViewDelegate?
    
    // MARK: - UI Components
    private let titleLabel = UILabel()
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 15
        $0.layer.masksToBounds = true
        $0.tintColor = .Turquoise
    }
    
    private let commentButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = .b6
        $0.contentHorizontalAlignment = .left
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
        
         [titleLabel, profileImageView, commentButton].forEach { addSubview($0) }
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
        
        commentButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.bottom.equalToSuperview().offset(-10)
        }
    }
    
    private func bind() {
        commentButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.delegate?.didCommentButtonTapped()
            })
            .disposed(by: disposeBag)
    }
}

extension MyVoteDetailCommentView {
    func configuration(comment: [Comment]) {
        if comment.isEmpty {
            let attributedString = NSMutableAttributedString(string: "댓글", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.black])
            attributedString.append(NSAttributedString(string: " \(comment.count)개", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.Turquoise]))
            titleLabel.attributedText = attributedString
            
            commentButton.setTitle("댓글이 없어요.", for: .normal)
            
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        } else {
            let attributedString = NSMutableAttributedString(string: "댓글", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.black])
            attributedString.append(NSAttributedString(string: " \(comment.count)개", attributes: [.font: UIFont.b6, .foregroundColor: UIColor.Turquoise]))
            titleLabel.attributedText = attributedString
            
            commentButton.setTitle(comment[0].content, for: .normal)
            profileImageView.setImageKingfisher(with: comment[0].authorProfileURL)
        }
    }
}
