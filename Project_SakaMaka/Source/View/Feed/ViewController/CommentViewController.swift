//
//  CommentViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 6/1/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

class CommentViewController: BaseViewController {
    
    private let viewModel: CommentViewModelType
    private let postID: String
    
    // MARK: - UI Components
    private lazy var headerView = CommentHeaderView().then {
        $0.delegate = self
    }
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.id)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapGesture))
        $0.addGestureRecognizer(gestureRecognizer)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 200
    }
    
    private lazy var footerView = CommentFooterView().then {
        $0.delegate = self
    }
    
    // MARK: - Init
    init(viewModel: CommentViewModelType = CommentViewModel(), postID: String) {
        self.viewModel = viewModel
        self.postID = postID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        super.setViewController()
        [headerView, tableView, footerView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        super.setConstraints()
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(headerView.snp.bottom)
            $0.bottom.equalTo(footerView.snp.top)
        }
        
        footerView.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(50)
        }
    }
    
    override func bind() {
        super.bind()
        
        viewModel.postID.onNext(postID)
        
        footerView.contentText
            .bind(to: viewModel.commentValue)
            .disposed(by: disposeBag)
        
        viewModel.commentsData
            .drive(tableView.rx.items(cellIdentifier: CommentTableViewCell.id, cellType: CommentTableViewCell.self)) { row, item, cell in
                cell.configuration(comment: item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - @objc
extension CommentViewController {
    @objc private func tableViewTapGesture(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

// MARK: - Delegate
extension CommentViewController: CommentHeaderViewDelegate {
    func didClosebuttonTapped() {
        self.dismiss(animated: true)
    }
}

extension CommentViewController: CommentFooterViewDelegate {
    func didAddCommentButtonTapped() {
        viewModel.addCommentButtonTapped.onNext(())
    }
}

// MARK: - Method
extension CommentViewController {
    private func setupKeyboardObservers() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .subscribe(onNext: { [weak self] notification in
                self?.handleKeyboardWillShow(notification)
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .subscribe(onNext: { [weak self] notification in
                self?.handleKeyboardWillHide(notification)
            })
            .disposed(by: disposeBag)
    }
    
    private func handleKeyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: animationDuration) {
            self.footerView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(keyboardHeight)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func handleKeyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        UIView.animate(withDuration: animationDuration) {
            self.footerView.snp.updateConstraints {
                $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
            }
            self.view.layoutIfNeeded()
        }
    }
}

