//
//  MyVoteDetailProgressView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/10/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class MyVoteDetailProgressView: UIView {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    private lazy var likeVoteProgressView = UIProgressView(progressViewStyle: .default).then {
        $0.layer.cornerRadius = 8
        $0.layer.sublayers![1].cornerRadius = 8
        $0.clipsToBounds = true
        $0.subviews[1].clipsToBounds = true
        $0.trackTintColor = .milkWhite
        $0.progressTintColor = .Turquoise
        $0.addSubview(likeVoteProgressSubLabel)
    }
    
    private let likeVoteProgressSubLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b5
        $0.textColor = .black
    }
    
    private lazy var  unlikeVoteProgressView = UIProgressView(progressViewStyle: .default).then {
        $0.layer.cornerRadius = 8
        $0.layer.sublayers![1].cornerRadius = 8
        $0.clipsToBounds = true
        $0.subviews[1].clipsToBounds = true
        $0.trackTintColor = .milkWhite
        $0.progressTintColor = .Turquoise
        $0.addSubview(unlikeVoteProgressSubLabel)
    }
    
    private let unlikeVoteProgressSubLabel = UILabel().then {
        $0.backgroundColor = .clear
        $0.font = .b5
        $0.textColor = .black
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp View
    private func setView() {
         [likeVoteProgressView, unlikeVoteProgressView].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        likeVoteProgressView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
        }
        
        likeVoteProgressSubLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
        
        unlikeVoteProgressView.snp.makeConstraints {
            $0.top.equalTo(likeVoteProgressView.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(45)
            $0.bottom.equalToSuperview()
        }
        
        unlikeVoteProgressSubLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(15)
        }
    }
}

extension MyVoteDetailProgressView {
    private func calculateVotePercentages(likeVotes: [String], unlikeVotes: [String]) -> (likePercentage: Double, unlikePercentage: Double) {
        let totalVotes = likeVotes.count + unlikeVotes.count
        guard totalVotes > 0 else { return (0, 0) }
        
        let likePercentage = (Double(likeVotes.count) / Double(totalVotes)) * 100
        let unlikePercentage = (Double(unlikeVotes.count) / Double(totalVotes)) * 100
        
        return (likePercentage, unlikePercentage)
    }
    
    func configuration(data: [Post]) {
        if !data.isEmpty {
            let percentages = calculateVotePercentages(likeVotes: data[0].likeVotes, unlikeVotes: data[0].unlikeVotes)
            
            likeVoteProgressSubLabel.text = "사라! \(String(format: "%.2f", percentages.likePercentage))%"
            unlikeVoteProgressSubLabel.text = "마라!  \(String(format: "%.2f", percentages.unlikePercentage))%"
            
            likeVoteProgressView.setProgress(Float(percentages.likePercentage / 100), animated: false)
            unlikeVoteProgressView.setProgress(Float(percentages.unlikePercentage / 100), animated: false)
        }
    }
}
