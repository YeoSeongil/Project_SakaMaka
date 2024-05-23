//
//  AddVoteContentView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol AddVoteContentViewDelegate: AnyObject {
}

class AddVoteContentView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: AddVoteContentViewDelegate?
    
    // MARK: - UI Components
    private let contentDescriptionLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "투표 내용을 입력해주세요.", attributes: [.font: UIFont.b2, .foregroundColor: UIColor.black])
        attributedString.append(NSAttributedString(string: " (선택사항)", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray]))
        $0.attributedText = attributedString
        $0.backgroundColor = .clear
    }
    
    private let contentTextView = UITextView().then {
        $0.font = .b4
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.nightGray.cgColor
        $0.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.text = "ex) 아이패드 9.7인치 살까? 아니면 12.9인치 살까?"
        $0.textColor = .nightGray
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
        backgroundColor = .clear
        
        [contentDescriptionLabel, contentTextView].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        contentDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalTo(contentDescriptionLabel.snp.bottom).offset(5)
            $0.height.equalTo(120)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func bind() {
        contentTextView.rx.text.orEmpty
            .map { $0.count <= 100 }
            .subscribe(with: self, onNext: { owner, isEditable in
                owner.characterLimitTitleTextField(isEditable)
            })
            .disposed(by: disposeBag)
        
//        contentTextView.rx.text.orEmpty
//            .map { $0.isEmpty }
//            .subscribe(with: self, onNext: { owner, isEmpty in
//                owner.changeContentTextFieldLayerColor(isEmpty)
//            })
//            .disposed(by: disposeBag)
        
        contentTextView.rx.didBeginEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.didBeginEditingEvent()
            })
            .disposed(by: disposeBag)
        
        contentTextView.rx.didEndEditing
            .subscribe(with: self, onNext: { owner, _ in
                owner.didEndEditingEvent()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Method
extension AddVoteContentView {
    private func characterLimitTitleTextField(_ isEditable: Bool) {
        if !isEditable {
            contentTextView.text = String(contentTextView.text?.dropLast() ?? "")
        }
    }
    
    private func changeContentTextFieldLayerColor(_ isEmpty: Bool) {
        contentTextView.layer.borderColor = isEmpty ? UIColor.nightGray.cgColor : UIColor.Turquoise.cgColor
    }
    
    private func didBeginEditingEvent() {
        if contentTextView.textColor == UIColor.nightGray {
            contentTextView.text = nil
            contentTextView.textColor = UIColor.Turquoise
            contentTextView.layer.borderColor = UIColor.Turquoise.cgColor
        }
    }
    
    private func didEndEditingEvent() {
        if contentTextView.text.isEmpty {
            contentTextView.text = "ex) 아이패드 9.7인치 살까? 아니면 12.9인치 살까?"
            contentTextView.textColor = UIColor.nightGray
            contentTextView.layer.borderColor = UIColor.nightGray.cgColor
        }
    }
}
