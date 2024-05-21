//
//  RegisterViewModel.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/21/24.
//

import RxCocoa
import RxSwift

import Firebase
import FirebaseStorage
import FirebaseFirestore

protocol RegisterViewModelType {
    // Input
    var saveButtonTapped: AnyObserver<Void> { get }
    var nickName: AnyObserver<String> { get }
    var profileImage: AnyObserver<UIImage> { get }
    
    // Output
    var registerResult: Driver<registerFirebaseUserType> { get }
}

class RegisterViewModel {
    private let disposeBag = DisposeBag()
    
    private let firebaseService = FireBaseService.shared
     
    private let inputSaveButtonTapped = PublishSubject<Void>()
    private let inputNickName = PublishSubject<String>()
    private let inputProfileImage = PublishSubject<UIImage>()
    
    private let outputRegisterResult = PublishRelay<registerFirebaseUserType>()
    
    init() {
        tryRegister()
    }
    
    private func tryRegister() {
        inputSaveButtonTapped
            .withLatestFrom(Observable.combineLatest(inputNickName, inputProfileImage))
            .subscribe(with: self, onNext: { owner, value in
                owner.firebaseService.registerFirebaseUser(nickName: value.0, image: value.1)
                    .subscribe(with: self, onNext: { owner, result in
                        owner.outputRegisterResult.accept(result)
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

extension RegisterViewModel: RegisterViewModelType {
    // Input
    var saveButtonTapped: AnyObserver<Void> {
        inputSaveButtonTapped.asObserver()
    }
    
    var nickName: AnyObserver<String> {
        inputNickName.asObserver()
    }
    
    var profileImage: AnyObserver<UIImage> {
        inputProfileImage.asObserver()
    }
    
    // Ouput
    var registerResult: Driver<registerFirebaseUserType> {
        outputRegisterResult.asDriver(onErrorDriveWith: .empty())
    }
}
