//
//  AddVoteSelectImageView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then
import PhotosUI

protocol AddVoteSelectImageViewDelegate: AnyObject {
    func didSelectImageButtonTapped()
}

class AddVoteSelectImageView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: AddVoteSelectImageViewDelegate?
    
    // MARK: - UI Components
    private let titleDescriptionLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "상품의 사진을 등록해주세요.", attributes: [.font: UIFont.b2, .foregroundColor: UIColor.black])
        attributedString.append(NSAttributedString(string: " (선택사항)", attributes: [.font: UIFont.b5, .foregroundColor: UIColor.nightGray]))
        $0.attributedText = attributedString
        $0.backgroundColor = .clear
    }
    
    private lazy var selectImageButton = UIButton().then {
        $0.setImage(UIImage(named: "selectImage")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.imageView?.layer.cornerRadius = 10
        $0.imageView?.contentMode = .scaleToFill
        $0.imageView?.clipsToBounds = true
        $0.backgroundColor = .clear
        $0.tintColor = .nightGray
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.nightGray.cgColor
        $0.layer.masksToBounds = true
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
        
        [titleDescriptionLabel, selectImageButton].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        titleDescriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        selectImageButton.snp.makeConstraints {
            $0.top.equalTo(titleDescriptionLabel.snp.bottom).offset(5)
            $0.height.equalTo(200)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bind() {
        selectImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.delegate?.didSelectImageButtonTapped()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Method
extension AddVoteSelectImageView {
    func setImage(_ image: UIImage) {
        selectImageButton.setImage(image, for: .normal)
        selectImageButton.layer.borderWidth = 0
    }
}
