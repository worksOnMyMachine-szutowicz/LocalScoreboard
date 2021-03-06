//
// Created by Krystian Szutowicz-EXT on 26/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

protocol AppCoordinatorInterface {
    func start()
}

class AppCoordinator: AppCoordinatorInterface, NewGameViewControllerDelegate, DicesViewControllerDelegate, DicesPlayerViewDelegate, InputPopoverViewControllerDelegate {
    private let navigationController: UINavigationController
    private let viewControllerFactory: AppCoordinatorFactoryProtocol

    init(navigationController: UINavigationController, viewControllerFactory: AppCoordinatorFactoryProtocol) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }

    func start() {
        navigationController.setViewControllers([viewControllerFactory.createNewGameViewController(delegate: self)], animated: true)
    }
    
    func pushRulesView(rulesViewData: RulesViewController.ViewData) {
        navigationController.pushViewController(viewControllerFactory.createRulesViewController(rulesViewData: rulesViewData), animated: true)
    }
    
    func startNewGame(game: GameData.Games, players: [String]) {
        switch game {
        case .thousandDices:
            navigationController.setViewControllers([viewControllerFactory.createDicesViewController(delegate: self, players: players)], animated: true)
        }
    }
    
    func quitGameConfirmation() -> Observable<DecisionAlertViewController.Decision> {
        let decisionAlertController = viewControllerFactory.createDecisionAlertViewController(viewData: .init(title: "quitGame.title".localized, message: "quitGame.message".localized, firstButton: .quit, secondButton: .cancel, backgroundAnimation: nil))
        navigationController.present(decisionAlertController, animated: true, completion: nil)
        
        return decisionAlertController.rx.output
    }
    
    func quitGame() {
        navigationController.setViewControllers([viewControllerFactory.createNewGameViewController(delegate: self)], animated: true)
    }
    
    func finishGame(winner: String) -> Observable<DecisionAlertViewController.Decision> {
        let decisionAlertController = viewControllerFactory.createDecisionAlertViewController(viewData: .init(title: String(format: "1000dices.finishGame.title".localized, arguments: [winner]), message: "1000dices.finishGame.message".localized, firstButton: .quit, secondButton: .ok, backgroundAnimation: .confetti))
        navigationController.present(decisionAlertController, animated: true, completion: nil)
        
        return decisionAlertController.rx.output
    }
    
    func startNewGame(players: [String]) {
        navigationController.setViewControllers([viewControllerFactory.createDicesViewController(delegate: self, players: players)], animated: true)
    }
    
    func showAddScoreView(for viewModel: InputPopoverViewModelInterface) -> Observable<Int?> {
        let inputPopoverController = viewControllerFactory.createInputPopoverViewController(viewModel: viewModel, delegate: self)
        navigationController.present(inputPopoverController, animated: true, completion: nil)
        
        return inputPopoverController.rx.output
    }
    
    func showInputWarning(with viewData: DecisionAlertViewController.ViewData, on vc: UIViewController) -> Observable<DecisionAlertViewController.Decision> {
        let decisionAlertController = viewControllerFactory.createDecisionAlertViewController(viewData: viewData)
        vc.present(decisionAlertController, animated: true, completion: nil)
        
        return decisionAlertController.rx.output
    }
}
