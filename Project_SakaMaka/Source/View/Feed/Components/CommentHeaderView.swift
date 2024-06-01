//
//  CommentHeaderView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/1/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol CommentHeaderViewDelegate: AnyObject {
    func didClosebuttonTapped()
}

class CommentHeaderView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: CommentHeaderViewDelegate?
    
    // MARK: - UI Components
    
    private let title = UILabel().then {
        $0.text = "댓글"
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.font = .h5
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .black
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
        
        [title, closeButton].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }

    }
    
    private func bind() {
        closeButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.delegate?.didClosebuttonTapped()
            })
            .disposed(by: disposeBag)
    }
}

extension CommentHeaderView {
    func configuration() {
        
    }
}
