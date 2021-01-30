//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

protocol ViewControllerFactoryProtocol {
    func createNewGameViewController(delegate: NewGameViewControllerDelegate) -> UIViewController
    func createRulesViewController(gameData: GameData) -> UIViewController
}

class ViewControllerFactory: ViewControllerFactoryProtocol {
    func createNewGameViewController(delegate: NewGameViewControllerDelegate) -> UIViewController {
        NewGameViewController(delegate: delegate, gameData: .thousandDices)
    }
    
    func createRulesViewController(gameData: GameData) -> UIViewController {
        return RulesViewController(viewData: gameData.rulesViewData)
    }
}
