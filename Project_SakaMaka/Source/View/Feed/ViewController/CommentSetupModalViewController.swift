//
//  CommentSetupViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/4/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class CommentSetupModalViewController: BaseViewController {

    var didDeleteButtonTapped: (() -> Void)?
    
    // MARK: - UI Components
    private let deleteButton = UIButton().then {
        $0.setTitle("댓글 삭제하기", for: .normal)
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
        
        view.addSubview(deleteButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        deleteButton.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview().inset(20)
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

