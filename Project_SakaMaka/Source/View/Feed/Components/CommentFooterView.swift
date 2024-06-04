//
//  CommentFooterView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/1/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol CommentFooterViewType {
    var contentText: Observable<String> { get }
    var replyContentText: Observable<String> { get }
    func textFieldEmpty()
    func hideCommentTextField()
}

protocol CommentFooterViewDelegate: AnyObject {
    func didAddCommentButtonTapped()
    func didAddReplyButtonTapped()
}

class CommentFooterView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: CommentFooterViewDelegate?
    
    // MARK: - UI Components
    
    private let lineView = CustomLineView().then {
        $0.lineColor = .nightGray
        $0.lineWidth = 1.0
    }
    
    private let profileImageView = UIImageView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 17.5
        $0.layer.masksToBounds = true

        $0.tintColor = .Turquoise
    }
    
    private let commentTextField = UITextField().then {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftView = padding
        $0.leftViewMode = .always
        $0.attributedPlaceholder = NSAttributedString(string: "투표에 대한 생각을 함께 나누어 보세요.", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray])
        $0.font = .b4
        $0.textColor = .Turquoise
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .milkWhite
    }

    private let replyTextField = UITextField().then {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftView = padding
        $0.leftViewMode = .always
        $0.attributedPlaceholder = NSAttributedString(string: "답글을 작성하세요.", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray])
        $0.font = .b4
        $0.textColor = .Turquoise
        $0.layer.cornerRadius = 8
        $0.backgroundColor = .milkWhite
        $0.isHidden = true // 기본적으로 숨김
    }
    
    private let addCommentButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane"), for: .normal)
        $0.tintColor = .black
        $0.layer.cornerRadius = 5
    }    
    
    private let addReplytButton = UIButton().then {
        $0.setImage(UIImage(systemName: "paperplane"), for: .normal)
        $0.tintColor = .black
        $0.layer.cornerRadius = 5
        $0.isHidden = true
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
        backgroundColor = .white
        
        replyTextField.delegate = self
        [lineView, profileImageView, commentTextField, replyTextField, addCommentButton, addReplytButton].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
            $0.width.height.equalTo(35)
        }
        
        commentTextField.snp.makeConstraints  {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(addCommentButton.snp.leading).offset(-10)
            $0.height.equalTo(35)
        }        
        
        replyTextField.snp.makeConstraints  {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(addCommentButton.snp.leading).offset(-10)
            $0.height.equalTo(35)
        }
        
        addCommentButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
            $0.trailing.equalToSuperview().inset(20)
        }        
        
        addReplytButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        addCommentButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.delegate?.didAddCommentButtonTapped()
            })
            .disposed(by: disposeBag)        
        
        addReplytButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                print("답글")
                owner.delegate?.didAddReplyButtonTapped()
            })
            .disposed(by: disposeBag)
    }
}

extension CommentFooterView {
    func configuration(url: String) {
        if url.isEmpty {
            profileImageView.image = UIImage(systemName: "person.crop.circle.fill")
        } else {
            profileImageView.setImageKingfisher(with: url)
        }
    }
}

extension CommentFooterView: CommentFooterViewType {
    var contentText: Observable<String> {
        commentTextField.rx.text.orEmpty
            .asObservable()
    }
    
    var replyContentText: Observable<String> {
        replyTextField.rx.text.orEmpty
            .asObservable()
    }
    
    func textFieldEmpty() {
        commentTextField.text = .none
        replyTextField.text = .none
    }
    
    func hideCommentTextField() {
        replyTextField.isHidden = false
        addReplytButton.isHidden = false
        if !replyTextField.isHidden {
            replyTextField.becomeFirstResponder() // 텍스트 필드를 보이게 하고 포커스를 줌
        }
    }
}

extension CommentFooterView: UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        replyTextField.isHidden = true
        addReplytButton.isHidden = true
        commentTextField.isHidden = false
        addCommentButton.isHidden = false
        textField.text = .none
        return true
    }
}
