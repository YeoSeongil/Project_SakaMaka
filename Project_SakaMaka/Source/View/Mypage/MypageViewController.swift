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
    
    private let viewModel: MypageViewModelType
    
    // MARK: - UI Components
    private lazy var headerView = MypageHeaderView().then {
        $0.delegate = self
    }
    
    private let mypageInfoView = MypageInfoView()
    
    // MARK: - Init
    
    init(viewModel: MypageViewModelType = MypageViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        [headerView, mypageInfoView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        mypageInfoView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(40)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(200)
        }
    }
    
    override func bind() {
        viewModel.userInfoData
            .drive(with: self, onNext: { owner, user in
                owner.mypageInfoView.configuration(user: user)
            })
            .disposed(by: disposeBag)
        
        viewModel.profileURL
            .drive(with: self, onNext: { owner, url in
                owner.mypageInfoView.setProfile(url: url)
            })
            .disposed(by: disposeBag)
    }
}

extension MypageViewController: MypageHeaderViewDelegate {
    func didSettingButtonTapped() {
        
    }
}
