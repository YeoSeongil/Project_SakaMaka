//
//  FeedSetupViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/29/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class FeedSetupModalViewController: BaseViewController {

    var didDeleteButtonTapped: (() -> Void)?
    
    // MARK: - UI Components
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.distribution = .fillEqually
    }
    
    private let editButton = UIButton().then {
        $0.setTitle("투표 수정하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
        $0.titleLabel?.font = .b2
        $0.backgroundColor = .clear

        let image = UIImage(systemName: "square.and.pencil")
        $0.setImage(image, for: .normal)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.contentHorizontalAlignment = .left
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitle("투표 삭제하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.tintColor = .black
        $0.titleLabel?.font = .b2
        $0.backgroundColor = .clear

        let image = UIImage(systemName: "trash")
        $0.setImage(image, for: .normal)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.contentHorizontalAlignment = .left
    }
    
    // MARK: - Init

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        super.setViewController()
        
        view.addSubview(stackView)
        [editButton, deleteButton].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        stackView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview().inset(20)
        }
        
        editButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    override func bind() {
        super.bind()
        
        deleteButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.didDeleteButtonTapped?()
            })
            .disposed(by: disposeBag)
    }
}

