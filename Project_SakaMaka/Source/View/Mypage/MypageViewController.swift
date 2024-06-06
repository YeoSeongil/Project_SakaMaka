//
//  HomeViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class MypageViewController: BaseViewController {

    private lazy var headerView = MypageHeaderView().then {
        $0.delegate = self
    }
    
    // MARK: - UI Components
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Init
    
    // MARK: - LifeCycle
    
    // MARK: - SetUp VC
    override func setViewController() {
        
        [headerView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
    }
}

extension MypageViewController: MypageHeaderViewDelegate {
    func didSettingButtonTapped() {
        
    }
}
