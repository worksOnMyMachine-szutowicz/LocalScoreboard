//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

protocol AppCoordinatorFactoryProtocol {
    func createNewGameViewController(delegate: NewGameViewControllerDelegate) -> UIViewController
    func createRulesViewController(rulesViewData: RulesViewController.ViewData) -> UIViewController
    func createDicesViewController(delegate: DicesViewControllerDelegate, players: [String]) -> UIViewController
    func createDecisionAlertViewController(viewData: DecisionAlertViewController.ViewData) -> DecisionAlertViewController
    func createInputPopoverViewController(viewModel: InputPopoverViewModelInterface, delegate: InputPopoverViewControllerDelegate) -> InputPopoverViewController
}

class AppCoordinatorFactory: AppCoordinatorFactoryProtocol {
    private let storageService: StorageServiceInterface
    
    init(storageService: StorageServiceInterface) {
        self.storageService = storageService
    }
    
    func createNewGameViewController(delegate: NewGameViewControllerDelegate) -> UIViewController {
        let viewModel = NewGameViewModel(gameData: .thousandDices)
        return NewGameViewController(delegate: delegate, viewModel: viewModel)
    }
    
    func createRulesViewController(rulesViewData: RulesViewController.ViewData) -> UIViewController {
        RulesViewController(viewData: rulesViewData)
    }
    
    func createDicesViewController(delegate: DicesViewControllerDelegate, players: [String]) -> UIViewController {
        let viewModel = DicesViewModel(players: players, storageService: storageService)
        return DicesViewController(delegate: delegate, viewModel: viewModel, viewFactory: DicesFactory())
    }
    
    func createDecisionAlertViewController(viewData: DecisionAlertViewController.ViewData) -> DecisionAlertViewController {
        DecisionAlertViewController(viewData: viewData)
    }
    
    func createInputPopoverViewController(viewModel: InputPopoverViewModelInterface, delegate: InputPopoverViewControllerDelegate) -> InputPopoverViewController {
        InputPopoverViewController(viewModel: viewModel, delegate: delegate)
    }
}
