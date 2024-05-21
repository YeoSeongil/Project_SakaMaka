//
//  RegisterViewController.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/20/24.
//

import UIKit

import RxCocoa
import RxSwift

import SnapKit
import Then

import PhotosUI

class RegisterViewController: BaseViewController {
    
    private let viewModel: RegisterViewModelType
    
    // MARK: - UI Components
    private let directionLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "사카마카", attributes: [.font: UIFont.h2, .foregroundColor: UIColor.Turquoise])
        attributedString.append(NSAttributedString(string: "에서\n사용할 프로필을 설정해주세요.", attributes: [.font: UIFont.h2_2, .foregroundColor: UIColor.black]))
        $0.attributedText = attributedString
        $0.numberOfLines = 2
    }
    
    private lazy var addProfileImageButton = UIButton().then {
        $0.addSubview(addProfileImageView)
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 50
    }
    
    private let addProfileImageView = UIImageView().then {
        $0.image = .unknownUser
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 50
    }
    
    private let addNickNameTextField = UITextField().then {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        $0.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [.font: UIFont.h5, .foregroundColor: UIColor.lightGray, .paragraphStyle: paragraphStyle])
        $0.font = .h5
        $0.textColor = .Turquoise
        $0.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.black.cgColor
    }
    
    private let saveButton = UIButton().then {
        $0.setTitle("시작하기", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = .b1
        $0.backgroundColor = .Turquoise
        $0.layer.cornerRadius = 10
    }
    
    // MARK: - Init
    init(viewModel: RegisterViewModelType = RegisterViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - SetUp VC
    override func setViewController() {
        super.setViewController()
        
        [directionLabel, addProfileImageButton, addNickNameTextField, saveButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setConstraints() {
        directionLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        addProfileImageButton.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalTo(view.safeAreaLayoutGuide).offset(-50)
            $0.height.width.equalTo(100)
        }
        
        addProfileImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.height.width.equalTo(100)
        }
        
        addNickNameTextField.snp.makeConstraints {
            $0.top.equalTo(addProfileImageButton.snp.bottom).offset(35)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.height.equalTo(45)
        }
        
        saveButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(60)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(25)
            $0.height.equalTo(50)
        }
    }
    
    override func bind() {
        addNickNameTextField.rx.text.orEmpty
            .map { $0.count <= 8 }
            .subscribe(with: self, onNext: { owner, isEditable in
                owner.characterLimitAddNickNameTextField(isEditable)
            })
            .disposed(by: disposeBag)
        
        addNickNameTextField.rx.text.orEmpty
            .map { $0.isEmpty }
            .subscribe(with: self, onNext: { owner, isEmpty in
                owner.saveButton.isEnabled  = !isEmpty
                owner.changeAddNickNameTextFieldLayerColor(isEmpty)
                owner.changeSaveButtonBackgroundColor(isEmpty)
            })
            .disposed(by: disposeBag)
        
        addProfileImageButton.rx.tap
            .subscribe(with: self, onNext: { owner, _ in
                owner.presentImagePicker()
            })
            .disposed(by: disposeBag)
        
        // Input
        saveButton.rx.tap
            .bind(to: viewModel.saveButtonTapped)
            .disposed(by: disposeBag)
        
        addNickNameTextField.rx.text.orEmpty
            .bind(to: viewModel.nickName)
            .disposed(by: disposeBag)
    }
}

extension RegisterViewController {
    private func characterLimitAddNickNameTextField(_ isEditable: Bool) {
        if !isEditable {
            addNickNameTextField.text = String(addNickNameTextField.text?.dropLast() ?? "")
        }
    }
    
    private func changeAddNickNameTextFieldLayerColor(_ isEmpty: Bool) {
        addNickNameTextField.layer.borderColor = isEmpty ? UIColor.lightGray.cgColor : UIColor.Turquoise.cgColor
    }
    
    private func changeSaveButtonBackgroundColor(_ isEmpty: Bool) {
        saveButton.backgroundColor = isEmpty ?  .lightGray : .Turquoise
    }
    
    private func presentImagePicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension RegisterViewController: PHPickerViewControllerDelegate {
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
                    self?.addProfileImageView.image = image
                    self?.viewModel.profileImage.onNext(image)
                }
            }
        }
    }
}
