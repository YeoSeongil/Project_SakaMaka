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

class FeedSetupViewController: BaseViewController {

    // MARK: - UI Components

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.backgroundColor = .clear
    }
    
    private let editButton = UIButton().then {
        $0.setTitle("투표 수정하기", for: .normal)
        $0.backgroundColor = .clear
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitle("투표 삭제하기", for: .normal)
        $0.backgroundColor = .clear
    }
    
    // MARK: - Init

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        view.addSubview(stackView)
        [editButton, deleteButton].forEach { stackView.addArrangedSubview($0) }
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        deleteButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    override func bind() {
    }
}

