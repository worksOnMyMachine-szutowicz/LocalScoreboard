//
//  DicesBoardViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 22/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DicesBoardViewModelInterface {
    var input: PublishRelay<DicesBoardViewModelInput> { get }
    var output: Driver<DicesBoardViewModelOutput> { get}
    
    var viewData: DicesBoardView.ViewData { get }
}

enum DicesBoardViewModelInput: EnumWithAssociatedValue {
    case toolbarButtonTapped(ToolbarButtonTappedModel)
    
    struct ToolbarButtonTappedModel { let type: DicesToolbarViewModelOutput }
    
    var associatedValue: Any {
        switch self {
        case .toolbarButtonTapped(let associatedValue):
            return associatedValue
        }
    }
}

enum DicesBoardViewModelOutput: EnumWithAssociatedValue {
    case currentPlayerChanged(CurrentPlayerChangedModel)
    case finishGame(FinishGameModel)
    
    struct CurrentPlayerChangedModel { let gamePhase: DicesPlayerViewModel.GamePhase }
    struct FinishGameModel { let winner: String }
    
    var associatedValue: Any {
        switch self {
        case .currentPlayerChanged(let associatedValue):
            return associatedValue
        case .finishGame(let associatedValue):
            return associatedValue
        }
    }
}
