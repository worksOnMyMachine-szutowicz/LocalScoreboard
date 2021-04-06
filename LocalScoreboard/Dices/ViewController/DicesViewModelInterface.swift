//
//  DicesViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 23/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DicesViewModelInterface {
    var input: PublishRelay<DicesViewModelInput> { get }
    var output: Driver<DicesViewModelOutput> { get }
    
    var viewData: DicesViewController.ViewData { get }
}

enum DicesViewModelInput: EnumWithAssociatedValue {
    case newGameDataRequest(NewGameDataRequest)
    
    struct NewGameDataRequest { }
    var associatedValue: Any {
        switch self {
        case .newGameDataRequest(let associatedValue):
            return associatedValue
        }
    }
}

enum DicesViewModelOutput: EnumWithAssociatedValue {
    case finishGame(FinishGameModel)
    case startNewGame(StartNewGameModel)
    
    struct FinishGameModel { let winner: String }
    struct StartNewGameModel { let players: [String] }
    
    var associatedValue: Any {
        switch self {
        case .finishGame(let associatedValue):
            return associatedValue
        case .startNewGame(let associatedValue):
            return associatedValue
        }
    }
}
