//
//  GamesData.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 30/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

struct GameData {
    enum Games {
        case thousandDices
    }
    
    let game: Games
    let requiredPlayers: Int
    let gameHeaderViewData: GameHeaderView.ViewData
    let rulesViewData: RulesViewController.ViewData
    
    static let thousandDices = GameData(game: .thousandDices, requiredPlayers: 2, gameHeaderViewData: .thousandDices, rulesViewData: .thousandDices)
}

extension GameHeaderView.ViewData {
    static let thousandDices = GameHeaderView.ViewData(titleLabelText: "1000dices.title".localized, descriptionLabelText: "1000dices.description".localized)
}

extension RulesViewController.ViewData {
    static let thousandDices = RulesViewController.ViewData(header: .thousandDices, sections: [.thousandDiceRequirements, .thousandDiceObjective, .thousandDiceRules])
}

extension TitledSectionView.ViewData {
    static let thousandDiceRequirements = TitledSectionView.ViewData(titleLabelText: "1000dices.rules.requirements.title".localized, contnetLabelText: "1000dices.rules.requirements.content".localized)
    
    static let thousandDiceObjective = TitledSectionView.ViewData(titleLabelText: "1000dices.rules.objective.title".localized, contnetLabelText: "1000dices.rules.objective.content".localized)
    
    static let thousandDiceRules = TitledSectionView.ViewData(titleLabelText: "1000dices.rules.rules.title".localized, contnetLabelText: "1000dices.rules.rules.content".localized)
}
