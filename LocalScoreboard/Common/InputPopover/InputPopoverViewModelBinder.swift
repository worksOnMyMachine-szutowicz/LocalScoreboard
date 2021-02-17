//
//  InputPopoverViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 16/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

protocol InputPopoverViewModelInterface {
    var input: PublishRelay<InputPopoverViewModelInput> { get }
    var output: Driver<InputPopoverViewModelOutput> { get }
    
    var viewData: InputPopoverViewController.ViewData { get }
}

enum InputPopoverViewModelInput: EnumWithAssociatedValue {
    case cancelButtonTapped(CancelButtonTappedModel)
    case saveButtonTapped(SaveButtonTappedModel)
    
    struct CancelButtonTappedModel { }
    struct SaveButtonTappedModel { let selections: [Int] }
    
    func associatedValue() -> Any {
        switch self {
        case .cancelButtonTapped(let associatedValue):
            return associatedValue
        case .saveButtonTapped(let associatedValue):
            return associatedValue
        }
    }
}

enum InputPopoverViewModelOutput: EnumWithAssociatedValue {
    case finishWithScore(FinishWithScoreModel)
    case showWarning(ShowWarningModel)
    case validationError(ValidationErrorModel)
    
    struct FinishWithScoreModel { let score: Int }
    struct ShowWarningModel {
        let score: Int
        let message: String
    }
    struct ValidationErrorModel { let message: String }
    
    func associatedValue() -> Any {
        switch self {
        case .finishWithScore(let associatedValue):
            return associatedValue
        case .showWarning(let associatedValue):
            return associatedValue
        case .validationError(let associatedValue):
            return associatedValue
        }
    }
}

struct InputPopoverViewModelValidationResultModel {
    enum ResultType {
        case ok
        case warning
        case error
    }
    let resultType: ResultType
    let message: String
}

protocol InputPopoverViewModelProtocol: RxInputOutput<InputPopoverViewModelInput, InputPopoverViewModelOutput> {
    func calculateScoreFor(selections: [Int]) -> Int
    func validate(score: Int) -> InputPopoverViewModelValidationResultModel
}

protocol InputPopoverViewModelBinder: InputPopoverViewModelProtocol, InputPopoverViewModelInterface { }

extension InputPopoverViewModelBinder {
    func setupBindigs() {
        input.asObservable().filterByAssociatedType(Input.CancelButtonTappedModel.self)
            .map { _ in Output.finishWithScore(.init(score: 0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
            
        let validationResult = input.asObservable().filterByAssociatedType(Input.SaveButtonTappedModel.self)
            .append(weak: self)
            .map { vm, input in vm.calculateScoreFor(selections: input.selections) }
            .append(weak: self)
            .map { vm, score in (validationResult: vm.validate(score: score), score: score) }
            .share()
        
        validationResult
            .filter { $0.validationResult.resultType == .ok }
            .map { Output.finishWithScore(.init(score: $0.score)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        validationResult
            .filter { $0.validationResult.resultType == .warning }
            .map { Output.showWarning(.init(score: $0.score, message: $0.validationResult.message)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        validationResult
            .filter { $0.validationResult.resultType == .error }
            .map { Output.validationError(.init(message: $0.validationResult.message)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
