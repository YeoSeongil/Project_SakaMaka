//
//  MypageHeaderView.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/6/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

protocol MypageHeaderViewDelegate: AnyObject {
    func didSettingButtonTapped()
}

class MypageHeaderView: UIView {
    
    private let disposeBag = DisposeBag()
    weak var delegate: MypageHeaderViewDelegate?
    
    // MARK: - UI Components
    private let title = UILabel().then {
        $0.text = "내정보"
        $0.font = .h2_2
        $0.backgroundColor = .clear
        $0.textColor = .black
    }
    
    private let settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "gearshape"), for: .normal)
        $0.tintColor = .nightGray
        $0.backgroundColor = .milkWhite
        $0.layer.cornerRadius = 5
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
        setConstraint()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetUp View
    private func setView() {
        backgroundColor = .clear
        
        [title, settingButton].forEach { addSubview($0) }
    }
    
    private func setConstraint() {
        title.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(20)
        }
        
        settingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func bind() {
        settingButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.delegate?.didSettingButtonTapped()
            })
            .disposed(by: disposeBag)
    }
}
