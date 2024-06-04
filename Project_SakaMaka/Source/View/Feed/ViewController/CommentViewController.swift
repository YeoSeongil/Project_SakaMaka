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
    private let profileURL: String
    
    private var isRepliesVisible: [String: Bool] = [:]
    private var comments: [Comment] = []
    
    // MARK: - UI Components
    private lazy var headerView = CommentHeaderView().then {
        $0.delegate = self
    }
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.id)
        $0.register(ReplyTableViewCell.self, forCellReuseIdentifier: ReplyTableViewCell.id)
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 100
        $0.separatorStyle = .none
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tableViewTapGesture))
        $0.addGestureRecognizer(gestureRecognizer)
    }
    
    private lazy var footerView = CommentFooterView().then {
        $0.delegate = self
        $0.configuration(url: profileURL)
    }
    
    // MARK: - Init
    init(viewModel: CommentViewModelType = CommentViewModel(), postID: String, profileURL: String) {
        self.viewModel = viewModel
        self.postID = postID
        self.profileURL = profileURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
        tableView.dataSource = self
        tableView.delegate = self
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
            .filter { !$0.isEmpty } 
            .bind(to: viewModel.commentValue)
            .disposed(by: disposeBag)
        
        footerView.replyContentText
            .filter { !$0.isEmpty }
            .bind(to: viewModel.replyValue)
            .disposed(by: disposeBag)
        
        viewModel.successAddComment
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.scrollToBottom()
                owner.footerView.textFieldEmpty()
            })
            .disposed(by: disposeBag)        
        
        viewModel.successAddReply
            .drive(with: self, onNext: { owner, _ in
                owner.view.endEditing(true)
                owner.footerView.textFieldEmpty()
            })
            .disposed(by: disposeBag)
        
        viewModel.commentsData
            .drive(with: self, onNext: { owner, comments in
                owner.comments = comments
                owner.isRepliesVisible = [:]
                owner.tableView.reloadData()
                owner.headerView.configuration(comment: comments)
            })
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
    
    func didAddReplyButtonTapped() {
        viewModel.addReplyButtonTapped.onNext(())
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
    
    private func didAddReplyButtonTapped(commentID: String) {
        footerView.hideCommentTextField()
        self.viewModel.commentID.onNext(commentID)
    }
    
    private func scrollToBottom() {
        let lastSection = tableView.numberOfSections - 1
        if lastSection >= 0 {
            let lastRow = tableView.numberOfRows(inSection: lastSection) - 1
            if lastRow >= 0 {
                let indexPath = IndexPath(row: lastRow, section: lastSection)
                tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    private func didCommentSetupButtonTapped(postID: String, commentID: String) {
        let modalViewController = CommentSetupModalViewController()
        
        if let sheet = modalViewController.sheetPresentationController {
            let fixedDetent = UISheetPresentationController.Detent.custom { context in
                return 70
            }
            
            sheet.detents = [fixedDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        
        modalViewController.didDeleteButtonTapped = { [weak self] in
            self?.viewModel.commentDeleteValue.onNext((postID, commentID))
            modalViewController.dismiss(animated: true)
        }
        
        present(modalViewController, animated: true, completion: nil)
    }    
    
    private func didReplySetupButtonTapped(postID: String, commentID: String, replyID: String) {
        let modalViewController = ReplySetupModalViewController()
        
        if let sheet = modalViewController.sheetPresentationController {
            let fixedDetent = UISheetPresentationController.Detent.custom { context in
                return 70
            }
            
            sheet.detents = [fixedDetent]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = true
        }
        
        modalViewController.didDeleteButtonTapped = { [weak self] in
            self?.viewModel.replyDeleteValue.onNext((postID, commentID, replyID))
            modalViewController.dismiss(animated: true)
        }
        
        present(modalViewController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let comment = comments[section]
        let isReplyVisible = isRepliesVisible[comment.id] ?? false
        return isReplyVisible ? comment.replies.count + 1 : 1 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = comments[indexPath.section]
        let isAuthor = self.viewModel.isCurrentUserAuthor(authorId: comment.authorID)
        
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.id, for: indexPath) as? CommentTableViewCell else {
                return UITableViewCell()
            }
            
            cell.onSetupButtonTapped = { [weak self] in
                self?.didCommentSetupButtonTapped(postID: comment.postID, commentID: comment.id)
            }
            cell.setButtonVisibility(isVisible: isAuthor)
            cell.configuration(comment: comment, isRepliesVisible: isRepliesVisible[comment.id] ?? false)
            
            // showRepliesAction 설정
            cell.showRepliesAction = { [weak self] in
                self?.toggleReplies(for: comment.id)
            }
            
            cell.onAddReplyButtonTapped = { [weak self] in
                self?.didAddReplyButtonTapped(commentID: comment.id)
            }
            
            return cell
        } else {
            let reply = comment.replies[indexPath.row - 1]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReplyTableViewCell.id, for: indexPath) as? ReplyTableViewCell else {
                return UITableViewCell()
            }
            cell.onSetupButtonTapped = { [weak self] in
                self?.didReplySetupButtonTapped(postID: comment.postID, commentID: comment.id, replyID: reply.id)
            }
            cell.setButtonVisibility(isVisible: isAuthor)
            cell.configuration(reply: reply)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension CommentViewController: UITableViewDelegate {
    private func toggleReplies(for commentId: String) {
        let isReplyVisible = isRepliesVisible[commentId] ?? false
        isRepliesVisible[commentId] = !isReplyVisible
        tableView.reloadData()
    }
}

