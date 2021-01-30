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
    
    var viewOutput: BehaviorRelay<String> { get }
    var viewData: DescribedTextFieldViewData { get }
}

enum DescribedTextFieldViewModelInput: EnumWithAssociatedValue {
    case update(UpdateModel)
    
    struct UpdateModel { let labelText: String }
    
    func associatedValue() -> Any {
        switch self {
        case .update(let associatedValue):
            return associatedValue
        }
    }
}

enum DescribedTextFieldViewModelOutput: EnumWithAssociatedValue {
    case error(Error)
    case updateView(UpdateViewModel)
    
    struct UpdateViewModel { let labelText: String }
    
    func associatedValue() -> Any {
        switch self {
        case .error(let associatedValue):
            return associatedValue
        case .updateView(let associatedValue):
            return associatedValue
        }
    }
}

struct DescribedTextFieldViewData {
    let labelText: String
}
