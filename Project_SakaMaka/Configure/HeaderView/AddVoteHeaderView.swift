//
//  AddVoteHeaderView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol AddVoteHeaderViewDelegate: AnyObject {
    func didBackbuttonTapped()
}

class AddVoteHeaderView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: AddVoteHeaderViewDelegate?
    
    // MARK: - UI Components
    private let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        $0.tintColor = .black
        $0.layer.cornerRadius = 5
    }
    
    private let title = UILabel().then {
        $0.text = "투표 만들기"
        $0.textColor = .black
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        $0.font = .b1
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
        
        [backButton, title].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        title.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    private func bind() {
        backButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.delegate?.didBackbuttonTapped()
            })
            .disposed(by: disposeBag)
    }
}
