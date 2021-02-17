//
//  GamesData.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 30/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

struct GameData {
    enum Games: Int {
        case thousandDices
    }
    
    let game: Games
    let requiredPlayers: Int
    let gameHeaderViewData: GameHeaderView.ViewData
    let rulesViewData: RulesViewController.ViewData
    
    static let games: [GameData] = [.thousandDices]
    static let thousandDices = GameData(game: .thousandDices, requiredPlayers: 2, gameHeaderViewData: .thousandDices, rulesViewData: .thousandDices)
    
    static func forGame(_ game: Games) -> GameData {
        games[game.rawValue]
    }
}

extension GameHeaderView.ViewData {
    static let thousandDices = GameHeaderView.ViewData(titleLabelText: "1000dices.title".localized, descriptionLabelText: "1000dices.description".localized)
}

extension RulesViewController.ViewData {
    static let thousandDices = RulesViewController.ViewData(header: .thousandDices, sections: [.thousandDiceRequirements, .thousandDiceObjective, .thousandDiceGeneralRules, .thousandDicePhaseOneRules, .thousandDicePhaseTwoRules])
}

extension TitledSectionView.ViewData {
    static let thousandDiceRequirements = TitledSectionView.ViewData(titleLabelText: "1000dices.rules.requirements.title".localized, contentLabelText: "1000dices.rules.requirements.content".localized)
    
    static let thousandDiceObjective = TitledSectionView.ViewData(titleLabelText: "1000dices.rules.objective.title".localized, contentLabelText: "1000dices.rules.objective.content".localized)
    
    static let thousandDiceGeneralRules = TitledSectionView.ViewData(titleLabelText: "1000dices.rules.generalRules.title".localized, contentLabelText: "1000dices.rules.generalRules.content".localized)
    
    static let thousandDicePhaseOneRules = TitledSectionView.ViewData(titleLabelText: "1000dices.rules.phaseOneRules.title".localized, contentLabelText: "1000dices.rules.phaseOneRules.content".localized)
    
    static let thousandDicePhaseTwoRules = TitledSectionView.ViewData(titleLabelText: "1000dices.rules.phaseTwoRules.title".localized, contentLabelText: "1000dices.rules.phaseTwoRules.content".localized)
}
