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
    
    struct FinishWithScoreModel { let score: Int }
    
    func associatedValue() -> Any {
        switch self {
        case .finishWithScore(let associatedValue):
            return associatedValue
        }
    }
}

protocol InputPopoverViewModelProtocol: RxInputOutput<InputPopoverViewModelInput, InputPopoverViewModelOutput> {
    func calculateScoreFor(selections: [Int]) -> Int
}

protocol InputPopoverViewModelBinder: InputPopoverViewModelProtocol, InputPopoverViewModelInterface { }

extension InputPopoverViewModelBinder {
    func setupBindigs() {
        input.asObservable().filterByAssociatedType(Input.CancelButtonTappedModel.self)
            .map { _ in Output.finishWithScore(.init(score: 0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.SaveButtonTappedModel.self)
            .append(weak: self)
            .map { vm, input in vm.calculateScoreFor(selections: input.selections) }
            .map { Output.finishWithScore(.init(score: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
