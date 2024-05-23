//
//  AddVoteLinkView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol AddVoteLinkViewDelegate: AnyObject {
}

class AddVoteLinkView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: AddVoteLinkViewDelegate?
    
    // MARK: - UI Components
    private let linkDescriptionLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "상품의 링크를 등록해주세요.", attributes: [.font: UIFont.b2, .foregroundColor: UIColor.black])
        attributedString.append(NSAttributedString(string: " (선택사항)", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray]))
        $0.attributedText = attributedString
        $0.backgroundColor = .clear
    }
    
    private let linkTextField = UITextField().then {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        $0.leftView = padding
        $0.leftViewMode = .always
        $0.attributedPlaceholder = NSAttributedString(string: "ex) https://itemlink.com", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray])
        $0.font = .b4
        $0.textColor = .Turquoise
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
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
        
        [linkDescriptionLabel, linkTextField].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        linkDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        linkTextField.snp.makeConstraints {
            $0.top.equalTo(linkDescriptionLabel.snp.bottom).offset(5)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    private func bind() {
        linkTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .subscribe(with: self, onNext: { owner, isEmpty in
                owner.changeLinkTextFieldLayerColor(isEmpty)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Method
extension AddVoteLinkView {
    private func changeLinkTextFieldLayerColor(_ isEmpty: Bool) {
        linkTextField.layer.borderColor = isEmpty ? UIColor.nightGray.cgColor : UIColor.Turquoise.cgColor
    }
}
