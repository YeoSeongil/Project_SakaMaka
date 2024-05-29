//
//  FeedViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class FeedViewController: BaseViewController {

    private let viewModel: FeedViewModelType
    
    // MARK: - UI Components
    private lazy var headerView = FeedHeaderView().then {
        $0.delegate = self
    }
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
    }
    
    private lazy var feedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .clear
        $0.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.id)
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Init
    init(viewModel: FeedViewModelType = FeedViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        [headerView, feedCollectionView].forEach { view.addSubview($0) }
    }
    
    override func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        feedCollectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func bind() {
        feedCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        viewModel.postsData
            .drive(feedCollectionView.rx.items(cellIdentifier: FeedCollectionViewCell.id, cellType: FeedCollectionViewCell.self)) { [weak self] row, item, cell in
                let isLiked = self?.viewModel.isCurrentUserLikedPost(postId: item.id)
                let isUnliked = self?.viewModel.isCurrentUserUnlikedPost(postId: item.id)
                let isAuthor = self?.viewModel.isCurrentUserAuthor(authorId: item.authorID) ?? false
                
                cell.onVoteBuyButtonTapped = { [weak self] in
                    self?.viewModel.voteBuyButtonTapped.onNext((item.id, "like"))
                }
                
                cell.onVoteDontBuyButtonTapped = { [weak self] in
                    self?.viewModel.voteDontBuyButtonTapped.onNext((item.id, "unlike"))
                }
                
                cell.configuration(item)
                cell.setButtonVisibility(isVisible: isAuthor)
                cell.setVoteButtonState(isLiked: isLiked ?? false, isUnliked: isUnliked ?? false)
            }.disposed(by: disposeBag)
    }
}

extension FeedViewController: FeedHeaderViewDelegate {
    func didAddVoteButtonTapped() {
        let vc = AddVoteViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.bounds.width
        let hegiht: CGFloat = 440
        return CGSize(width: width, height: hegiht)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 45
    }
}

