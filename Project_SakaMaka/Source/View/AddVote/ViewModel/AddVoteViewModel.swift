//
//  AddVoteViewModel.swift
//  Project_SakaMaka
//
//  Created by 여성일 on 5/23/24.
//

import RxCocoa
import RxSwift

protocol AddVoteViewModelType {
    var postButtonTapped: AnyObserver<Void> { get }
    var titleValue: AnyObserver<String> { get }
    var imageValue: AnyObserver<UIImage> { get }
    var priceValue: AnyObserver<String> { get }
    var linkValue: AnyObserver<String> { get }
    var contentValue: AnyObserver<String> { get }
}

class AddVoteViewModel {
    private let disposeBag = DisposeBag()
    
    private let firebaseService = FireBaseService.shared
    // Input
    private let inputPostButtonTapped = PublishSubject<Void>()
    private let inputTitleValue = PublishSubject<String>()
    private let inputImageValue = PublishSubject<UIImage>()
    private let inputPriceValue = PublishSubject<String>()
    private let inputLinkValue = PublishSubject<String>()
    private let inputContentValue = PublishSubject<String>()
    
    init() {
        inputPostButtonTapped
            .withLatestFrom(Observable.combineLatest(inputTitleValue, inputImageValue, inputPriceValue, inputLinkValue, inputContentValue))
            .subscribe(with: self, onNext: { owner, value in
                owner.firebaseService.postUpload(title: value.0, image: value.1, price: value.2, link: value.3, content: value.4)
                    .subscribe(onNext: { result in
                        switch result {
                        case .success:
                            print("성공")
                        case .handleError:
                            print("실패")
                        }
                    }).disposed(by: self.disposeBag)
            })
            .disposed(by: disposeBag)
    }
}

extension AddVoteViewModel: AddVoteViewModelType {
    var postButtonTapped: AnyObserver<Void> {
        inputPostButtonTapped.asObserver()
    }
    
    var titleValue: AnyObserver<String> {
        inputTitleValue.asObserver()
    }
    
    var imageValue: AnyObserver<UIImage> {
        inputImageValue.asObserver()
    }
    
    var priceValue: AnyObserver<String> {
        inputPriceValue.asObserver()
    }
    
    var linkValue: AnyObserver<String> {
        inputLinkValue.asObserver()
    }
    
    var contentValue: AnyObserver<String> {
        inputContentValue.asObserver()
    }
}
