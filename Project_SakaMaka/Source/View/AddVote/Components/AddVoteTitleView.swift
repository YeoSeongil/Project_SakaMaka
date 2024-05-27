//
//  AddVoteTitleView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol AddVoteTitleViewType {
    var titleText: Observable<String> { get }
}

class AddVoteTitleView: UIView {
     
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let titleDescriptionLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "투표 제목을 입력해주세요.", attributes: [.font: UIFont.b2, .foregroundColor: UIColor.black])
        attributedString.append(NSAttributedString(string: " (필수사항)", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.wineRed]))
        $0.attributedText = attributedString
        $0.backgroundColor = .clear
    }
    
    private let titleTextField = UITextField().then {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftView = padding
        $0.leftViewMode = .always
        $0.attributedPlaceholder = NSAttributedString(string: "ex) 아이패드 살까?", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray])
        $0.font = .b4
        $0.textColor = .Turquoise
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private let emptyWarningMessageLabel = UILabel().then {
        $0.text = "제목은 필수로 입력해야 합니다."
        $0.font = .b5
        $0.textColor = .wineRed
        $0.backgroundColor  = .clear
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
        
        [titleDescriptionLabel, titleTextField, emptyWarningMessageLabel].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        titleDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(5)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyWarningMessageLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(3)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        titleTextField.rx.text.orEmpty
            .map { $0.count <= 15 }
            .subscribe(with: self, onNext: { owner, isEditable in
                owner.characterLimitTitleTextField(isEditable)
            })
            .disposed(by: disposeBag)
        
        titleTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .subscribe(with: self, onNext: { owner, isEmpty in
                owner.emptyTitleTextField(isEmpty)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Method
extension AddVoteTitleView {
    private func characterLimitTitleTextField(_ isEditable: Bool) {
        if !isEditable {
            titleTextField.text = String(titleTextField.text?.dropLast() ?? "")
        }
    }
    
    private func emptyTitleTextField(_ isEmpty: Bool) {
        if isEmpty {
            titleTextField.layer.borderColor = UIColor.wineRed.cgColor
            emptyWarningMessageLabel.isHidden = false
        } else {
            titleTextField.layer.borderColor = UIColor.Turquoise.cgColor
            emptyWarningMessageLabel.isHidden = true
        }
    }
}

extension AddVoteTitleView: AddVoteTitleViewType {
    var titleText: Observable<String> {
        titleTextField.rx.text.orEmpty
            .asObservable()
    }
}
