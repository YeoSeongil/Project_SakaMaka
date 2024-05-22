//
//  AddVoteViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class AddVoteViewController: BaseViewController {

    // MARK: - UI Components
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.backgroundColor = .clear
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.addSubview(stackView)
    }
    
    // MARK: - Init
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        [scrollView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        scrollView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
}
