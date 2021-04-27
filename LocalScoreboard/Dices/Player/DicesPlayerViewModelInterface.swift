//
//  DicesPlayerViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 08/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DicesPlayerViewModelInterface {
    var input: PublishRelay<DicesPlayerViewModelInput> { get }
    var output: Driver<DicesPlayerViewModelOutput> { get }
    
    var viewData: DicesPlayerView.ViewData { get }
}

enum DicesPlayerViewModelInput: EnumWithAssociatedValue {
    case viewDidLoad(ViewDidLoadModel)
    case addScoreTapped(AddScoreTappedModel)
    case punishmentTapped(PunishmentTappedModel)
    case addScore(AddScoreModel)
    case playerSurpassed(PlayerSurpassedModel)
    case currentPlayer(CurrentPlayerModel)
    
    struct ViewDidLoadModel { }
    struct AddScoreTappedModel { }
    struct AddScoreModel { let score: Int }
    struct PunishmentTappedModel { }
    struct PlayerSurpassedModel { }
    struct CurrentPlayerModel { let value: Bool }
    
    var associatedValue: Any {
        switch self {
        case .viewDidLoad(let associatedValue):
            return associatedValue
        case .addScoreTapped(let associatedValue):
            return associatedValue
        case .punishmentTapped(let associatedValue):
            return associatedValue
        case .addScore(let associatedValue):
            return associatedValue
        case .playerSurpassed(let associatedValue):
            return associatedValue
        case .currentPlayer(let associatedValue):
            return associatedValue
        }
    }
}

enum DicesPlayerViewModelOutput: EnumWithAssociatedValue {
    case showInputPopover(ShowInputPopoverModel)
    case scoreChanged(ScoreChangedModel)
    case playerWon(PlayerWon)
    case becomedCurrentPlayer(BecomedCurrentPlayerModel)
    case resignedCurrentPlayer(ResignedCurrentPlayerModel)
    case newStatus(NewStatusModel)
    case removeStatus(RemoveStatusModel)
    
    struct ShowInputPopoverModel { let inputPopoverViewModel: InputPopoverViewModelInterface}
    struct ScoreChangedModel {
        let startedFrom: Int
        let stepScore: Int
    }
    struct PlayerWon { let playerName: String }
    struct BecomedCurrentPlayerModel {
        let playerIndex: Int
        let gamePhase: DicesPlayerViewModel.GamePhase
    }
    struct ResignedCurrentPlayerModel { }
    struct NewStatusModel {
        let status: DicesPlayerStatusView.Statuses
        let duration: Double?
    }
    struct RemoveStatusModel { let status: DicesPlayerStatusView.Statuses }
    
    var associatedValue: Any {
        switch self {
        case .showInputPopover(let associatedValue):
            return associatedValue
        case .scoreChanged(let associatedValue):
            return associatedValue
        case .playerWon(let associatedValue):
            return associatedValue
        case .becomedCurrentPlayer(let associatedValue):
            return associatedValue
        case .resignedCurrentPlayer(let associatedValue):
            return associatedValue
        case .newStatus(let associatedValue):
            return associatedValue
        case .removeStatus(let associatedValue):
            return associatedValue
        }
    }
}
