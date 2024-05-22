//
//  FeedHeaderView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol FeedHeaderViewDelegate: AnyObject {
    func didAddVoteButtonTapped()
}

class FeedHeaderView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: FeedHeaderViewDelegate?
    
    // MARK: - UI Components
    private let title = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "사카", attributes: [.font: UIFont.h2, .foregroundColor: UIColor.Turquoise])
        attributedString.append(NSAttributedString(string: "마카", attributes: [.font: UIFont.h2_2, .foregroundColor: UIColor.black]))
        $0.attributedText = attributedString
    }
    
    private let addVoteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.tintColor = .nightGray
        $0.backgroundColor = .milkWhite
        $0.layer.cornerRadius = 5
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
        
        [title, addVoteButton].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        addVoteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        addVoteButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.delegate?.didAddVoteButtonTapped()
            })
            .disposed(by: disposeBag)
    }
}
