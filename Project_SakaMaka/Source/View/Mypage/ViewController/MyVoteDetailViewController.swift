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
    private let contentView = MyVoteDetailContentView()
    
    private let commentView = MyVoteDetailCommentView().then {
        $0.layer.cornerRadius = 8
    }
    private let voteProgressView = MyVoteDetailProgressView()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
        $0.backgroundColor = .clear
        $0.distribution =  .equalSpacing
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
        // Do any additional setup after loading the view.
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        super.setViewController()
        [headerView, stackView].forEach {
            view.addSubview($0)
        }
        
        [contentView, voteProgressView, commentView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
    }
    
    override func bind() {
        super.bind()
        viewModel.postID.onNext(postID)
        
        viewModel.detailPost
            .drive(with: self, onNext: { owner, post in
                owner.voteProgressView.configuration(data: post)
                owner.contentView.configuration(data: post)
            })
            .disposed(by: disposeBag)
        
        viewModel.detailComment
            .drive(with: self, onNext: { owner, comment in
                owner.commentView.configuration(comment: comment)
            })
            .disposed(by: disposeBag)    }
}

extension MyVoteDetailViewController {

}

// MARK: - Delegate
extension MyVoteDetailViewController: MyVoteDetailHeaderViewDelegate {
    func didBackbuttonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
