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
    
    private let collectionViewLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 3
        $0.minimumLineSpacing = 3
    }
    
    private let myFeedLabel =  UILabel().then {
        let attributedString = NSMutableAttributedString(string: "나의 투표", attributes: [.font: UIFont.b1, .foregroundColor: UIColor.black])
        attributedString.append(NSAttributedString(string: " 0", attributes: [.font: UIFont.b3, .foregroundColor: UIColor.Turquoise]))
        $0.attributedText = attributedString
    }

    private lazy var myFeedCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: collectionViewLayout
    ).then {
        $0.backgroundColor = .clear
        $0.register(MyFeedCollectionViewCell.self, forCellWithReuseIdentifier: MyFeedCollectionViewCell.id)
        $0.showsVerticalScrollIndicator = false
    }
    
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
        [headerView, mypageInfoView, myFeedLabel, myFeedCollectionView].forEach {
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
        
        myFeedLabel.snp.makeConstraints {
            $0.top.equalTo(mypageInfoView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        
        myFeedCollectionView.snp.makeConstraints {
            $0.top.equalTo(myFeedLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func bind() {
        myFeedCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
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
        
        viewModel.postTumbnailURL
            .drive(myFeedCollectionView.rx.items(cellIdentifier: MyFeedCollectionViewCell.id, cellType: MyFeedCollectionViewCell.self)) { [weak self] row, item, cell in
                self?.myFeedCollectionView.reloadData()
                cell.configuration(url: item)
            }.disposed(by: disposeBag)
        
        viewModel.postTumbnailURL
            .drive(with:self, onNext: { owner, urls in
                let attributedString = NSMutableAttributedString(string: "나의 투표", attributes: [.font: UIFont.b1, .foregroundColor: UIColor.black])
                attributedString.append(NSAttributedString(string: " \(urls.count)", attributes: [.font: UIFont.b3, .foregroundColor: UIColor.Turquoise]))
                owner.myFeedLabel.attributedText = attributedString
            })
            .disposed(by: disposeBag)
    }
}

extension MypageViewController: MypageHeaderViewDelegate {
    func didSettingButtonTapped() {
        
    }
}

extension MypageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let paddingSpace = 3 * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
}
