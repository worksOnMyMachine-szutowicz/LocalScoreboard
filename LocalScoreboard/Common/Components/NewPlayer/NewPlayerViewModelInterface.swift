//
//  NewPlayerViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol NewPlayerViewModelInterface {
    var input: PublishRelay<NewPlayerViewModelInput> { get }
    var output: Driver<NewPlayerViewModelOutput> { get }
    
    var viewData: NewPlayerView.ViewData { get }
}

enum NewPlayerViewModelInput: EnumWithAssociatedValue {
    //internal
    case deleteTapped(DeleteTappedModel)
    
    //external
    case updateIndex(UpdateIndexModel)
    case validate(ValidateModel)
    
    struct UpdateIndexModel { }
    struct DeleteTappedModel { }
    struct ValidateModel { }
    
    var associatedValue: Any {
        switch self {
        case .updateIndex(let associatedValue):
            return associatedValue
        case .deleteTapped(let associatedValue):
            return associatedValue
        case .validate(let associatedValue):
            return associatedValue
        }
    }
}

enum NewPlayerViewModelOutput: EnumWithAssociatedValue {
    //external
    case delete(DeleteModel)
    case validationResult(ValidationResultModel)
    
    struct DeleteModel { let index: Int }
    struct ValidationResultModel {
        let result: Bool
        let userInput: String
    }
    
    var associatedValue: Any {
        switch self {
        case .delete(let associatedValue):
            return associatedValue
        case .validationResult(let associatedValue):
            return associatedValue
        }
    }
}
