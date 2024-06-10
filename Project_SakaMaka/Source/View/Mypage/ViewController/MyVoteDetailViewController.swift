//
//  MyVoteDetailViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/9/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class MyVoteDetailViewController: BaseViewController {
    
    private let postID: String
    private let viewModel: MypageViewModelType
    
    // MARK: - UI Components
    private lazy var headerView = MyVoteDetailHeaderView().then {
        $0.delegate = self
    }
    
    // MARK: - Init
    init(viewModel: MypageViewModelType = MypageViewModel(), postID: String) {
        self.postID = postID
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(postID)
        // Do any additional setup after loading the view.
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        super.setViewController()
        [headerView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
    }
    
    override func bind() {
    }
}

// MARK: - Delegate
extension MyVoteDetailViewController: MyVoteDetailHeaderViewDelegate {
    func didBackbuttonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
