//
//  NewGameViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 31/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol NewGameViewModelInterface {
    var input: PublishRelay<NewGameViewModelInput> { get }
    var output: Driver<NewGameViewModelOutput> { get }
    
    var viewData: NewGameViewController.ViewData { get }
}

enum NewGameViewModelInput: EnumWithAssociatedValue {
    case playButtonTapped(PlayButtonTappedModel)
    case rulesButtonTapped(RulesButtonTappedModel)
    
    struct PlayButtonTappedModel { }
    struct RulesButtonTappedModel { }
    
    func associatedValue() -> Any {
        switch self {
        case .playButtonTapped(let associatedValue):
            return associatedValue
        case .rulesButtonTapped(let associatedValue):
            return associatedValue
        }
    }
}

enum NewGameViewModelOutput: EnumWithAssociatedValue {
    case showRulesView(ShowRulesView)
    case startNewGame(StartNewGameModel)
    
    struct ShowRulesView { let rulesViewData: RulesViewController.ViewData }
    struct StartNewGameModel {
        let game: GameData.Games
        let players: [String]
    }
    
    func associatedValue() -> Any {
        switch self {
        case .showRulesView(let associatedValue):
            return associatedValue
        case .startNewGame(let associatedValue):
            return associatedValue
        }
    }
}
