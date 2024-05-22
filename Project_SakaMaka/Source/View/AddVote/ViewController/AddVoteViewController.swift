//
//  AddVoteViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/22/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

import PhotosUI

class AddVoteViewController: BaseViewController {

    // MARK: - UI Components
    private lazy var headerView = AddVoteHeaderView().then {
        $0.delegate = self
    }
    
    private let addVoteTitleView = AddVoteTitleView()
    private lazy var addVoteSelectImageView = AddVoteSelectImageView().then {
        $0.delegate = self
    }
    private let addVotePriceView = AddVotePriceView()
    private let addVoteLinkView = AddVoteLinkView()
    private let addVoteContentView = AddVoteContentView()
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 35
        $0.backgroundColor = .clear
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.addSubview(stackView)
    }

    private let addButton = UIButton().then {
        $0.setTitle("등록하기", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = .h4
        $0.backgroundColor = .Turquoise
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - Init
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        [headerView, scrollView, addButton].forEach {
            view.addSubview($0)
        }
        
        [addVoteTitleView, addVoteSelectImageView, addVotePriceView, addVoteLinkView, addVoteContentView].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func setConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(32)
        }
        
        addVoteContentView.snp.makeConstraints {
            $0.height.equalTo(220)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.width.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(25)
            $0.bottom.equalTo(addButton.snp.top).offset(25)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        addButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - Method
extension AddVoteViewController {
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension AddVoteViewController: AddVoteHeaderViewDelegate {
    func didBackbuttonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddVoteViewController: AddVoteSelectImageViewDelegate {
    func didSelectImageButtonTapped() {
        presentImagePicker()
    }
    
    func didSelectImageTapped() {
        
    }
}

extension AddVoteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                return
            }
            
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] (url, error) in
                if let error = error {
                    print("Error loading image URL: \(error.localizedDescription)")
                    return
                }
                
                guard let image = object as? UIImage else { return }
                
                DispatchQueue.main.async {
                    self?.addVoteSelectImageView.setImage(image)
                }
            }
        }
    }
}
