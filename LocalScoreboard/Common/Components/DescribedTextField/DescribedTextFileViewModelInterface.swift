//
//  DescribedTextFileViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DescribedTextFieldViewModelInterface {
    var input: PublishRelay<DescribedTextFieldViewModelInput> { get }
    var output: Driver<DescribedTextFieldViewModelOutput> { get }
    
    var viewData: DescribedTextFieldView.ViewData { get }
}

enum DescribedTextFieldViewModelInput: EnumWithAssociatedValue {
    //internal
    case userInput(UserInput)
    
    //external
    case update(UpdateModel)
    case validate(ValidateModel)
    
    struct UserInput { let input: String }
    struct UpdateModel { let labelText: String }
    struct ValidateModel { }
    
    var associatedValue: Any {
        switch self {
        case .userInput(let associatedValue):
            return associatedValue
        case .update(let associatedValue):
            return associatedValue
        case .validate(let associatedValue):
            return associatedValue
        }
    }
}

enum DescribedTextFieldViewModelOutput: EnumWithAssociatedValue {
    //internal
    case updateView(UpdateViewModel)
    
    //internal && external
    case validationResult(ValidationResultModel)
    
    struct UpdateViewModel { let labelText: String }
    struct ValidationResultModel {
        let result: Bool
        let userInput: String
    }
    
    var associatedValue: Any {
        switch self {
        case .updateView(let associatedValue):
            return associatedValue
        case .validationResult(let associatedValue):
            return associatedValue
        }
    }
}
