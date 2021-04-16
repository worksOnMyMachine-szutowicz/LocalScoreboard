//
//  DicesToolbarViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 06/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DicesToolbarViewModelInterface {
    var input: PublishRelay<DicesToolbarViewModelInput> { get }
    var output: Driver<DicesToolbarViewModelOutput> { get }
}

enum DicesToolbarViewModelInput: EnumWithAssociatedValue {
    //external
    case refresh(RefreshModel)
    
    //internal
    case addTapped(AddTappedModel)
    case punishmentTapped(PunishmentTappedModel)
    case nextTapped(NextTappedModel)
    
    struct RefreshModel { let gamePhase: DicesPlayerViewModel.GamePhase }
    struct AddTappedModel { }
    struct PunishmentTappedModel { }
    struct NextTappedModel { }
    
    var associatedValue: Any {
        switch self {
        case .refresh(let associatedValue):
            return associatedValue
        case .addTapped(let associatedValue):
            return associatedValue
        case .punishmentTapped(let associatedValue):
            return associatedValue
        case .nextTapped(let associatedValue):
            return associatedValue
        }
    }
}

enum DicesToolbarViewModelOutput: EnumWithAssociatedValue {
    //internal
    case refresh(RefreshModel)
    
    //external
    case add(AddModel)
    case punishment(PunishmentModel)
    case next(NextModel)
    
    struct RefreshModel { let buttons: [DicesToolbarViewModel.ButtonViewData] }
    struct AddModel { }
    struct PunishmentModel { }
    struct NextModel { }
    
    var associatedValue: Any {
        switch self {
        case .refresh(let associatedValue):
            return associatedValue
        case .add(let associatedValue):
            return associatedValue
        case .punishment(let associatedValue):
            return associatedValue
        case .next(let associatedValue):
            return associatedValue
        }
    }
}
