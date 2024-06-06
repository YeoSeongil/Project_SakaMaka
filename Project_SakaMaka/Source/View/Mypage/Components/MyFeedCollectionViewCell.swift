//
//  MyFeedCollectionViewCell.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/6/24.
//

import UIKit

import Then
import SnapKit

import RxSwift
import RxCocoa

class MyFeedCollectionViewCell: UICollectionViewCell {
    static let id: String = "MyFeedCollectionViewCell"
    
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Components
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.tintColor = .milkWhite
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCell()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Setup Cell
    private func setCell() {
        backgroundColor = .milkWhite
        addSubview(thumbnailImageView)
    }
    
    private func setConstraint() {
        thumbnailImageView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }
}

extension MyFeedCollectionViewCell {
    func configuration(url: Thumbnail) {
        thumbnailImageView.setImageKingfisher(with: url.url)
    }
}
