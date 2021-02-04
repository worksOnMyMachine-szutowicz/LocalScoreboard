//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

protocol ViewControllerFactoryProtocol {
    func createNewGameViewController(delegate: NewGameViewControllerDelegate) -> UIViewController
    func createRulesViewController(rulesViewData: RulesViewController.ViewData) -> UIViewController
    func createDicesViewController(delegate: DicesViewControllerDelegate, players: [String]) -> UIViewController
}

class ViewControllerFactory: ViewControllerFactoryProtocol {
    func createNewGameViewController(delegate: NewGameViewControllerDelegate) -> UIViewController {
        let viewModel = NewGameViewModel(gameData: .thousandDices)
        return NewGameViewController(delegate: delegate, viewModel: viewModel)
    }
    
    func createRulesViewController(rulesViewData: RulesViewController.ViewData) -> UIViewController {
        RulesViewController(viewData: rulesViewData)
    }
    
    func createDicesViewController(delegate: DicesViewControllerDelegate, players: [String]) -> UIViewController {
        DicesViewController(delegate: delegate, viewData: .init(players: players))
    }
}
