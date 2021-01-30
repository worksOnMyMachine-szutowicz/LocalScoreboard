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
    
    var viewData: NewPlayerViewData { get }
}

enum NewPlayerViewModelInput: EnumWithAssociatedValue {
    case updateIndex(UpdateIndexModel)
    case deleteTapped(DeleteTappedModel)
    
    struct UpdateIndexModel { }
    struct DeleteTappedModel { }
    
    func associatedValue() -> Any {
        switch self {
        case .updateIndex(let associatedValue):
            return associatedValue
        case .deleteTapped(let associatedValue):
            return associatedValue
        }
    }
}

enum NewPlayerViewModelOutput: EnumWithAssociatedValue {
    case error(Error)
    case delete(DeleteModel)
    
    struct UpdateModel { let index: Int }
    struct DeleteModel { let index: Int }
    
    func associatedValue() -> Any {
        switch self {
        case .error(let associatedValue):
            return associatedValue
        case .delete(let associatedValue):
            return associatedValue
        }
    }
}

struct NewPlayerViewData {
    let descibedTextFieldViewModel: DescribedTextFieldViewModelInterface
    let canBeDeleted: Bool
    var index: Int
}
