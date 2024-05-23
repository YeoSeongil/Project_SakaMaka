//
//  AddVotePriceView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol AddVotePriceViewType {
    var priceText: Observable<String> { get }
}

class AddVotePriceView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private let priceDescriptionLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "상품의 가격을 입력해주세요.", attributes: [.font: UIFont.b2, .foregroundColor: UIColor.black])
        attributedString.append(NSAttributedString(string: " (선택사항)", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray]))
        $0.attributedText = attributedString
        $0.backgroundColor = .clear
    }
    
    private let priceTextField = UITextField().then {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftView = padding
        $0.leftViewMode = .always
        $0.attributedPlaceholder = NSAttributedString(string: "ex) 10000", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray])
        $0.font = .b4
        $0.textColor = .Turquoise
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
        $0.keyboardType = .numberPad
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
        
        [priceDescriptionLabel, priceTextField].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        priceDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(priceDescriptionLabel.snp.bottom).offset(5)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        priceTextField.rx.text.orEmpty
            .map { $0.count <= 13 }
            .subscribe(with: self, onNext: { owner, isEditable in
                owner.characterLimitTitleTextField(isEditable)
            })
            .disposed(by: disposeBag)
        
        priceTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .subscribe(with: self, onNext: { owner, isEmpty in
                owner.changePriceTextFieldLayerColor(isEmpty)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Method
extension AddVotePriceView {
    private func characterLimitTitleTextField(_ isEditable: Bool) {
        if !isEditable {
            priceTextField.text = String(priceTextField.text?.dropLast() ?? "")
        }
    }
    
    private func changePriceTextFieldLayerColor(_ isEmpty: Bool) {
        priceTextField.layer.borderColor = isEmpty ? UIColor.nightGray.cgColor : UIColor.Turquoise.cgColor
    }
}

extension AddVotePriceView: AddVotePriceViewType {
    var priceText: Observable<String> {
        priceTextField.rx.text.orEmpty
            .asObservable()
    }
}
