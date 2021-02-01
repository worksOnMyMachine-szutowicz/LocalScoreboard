//
// Created by Krystian Szutowicz-EXT on 26/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

protocol AppCoordinatorInterface {
    func start()
}

class AppCoordinator: AppCoordinatorInterface, NewGameViewControllerDelegate {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private let viewControllerFactory: ViewControllerFactoryProtocol

    init(window: UIWindow, navigationController: UINavigationController, viewControllerFactory: ViewControllerFactoryProtocol) {
        self.window = window
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }

    func start() {
        let homeVc = viewControllerFactory.createNewGameViewController(delegate: self)
        navigationController.setViewControllers([homeVc], animated: true)

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func pushRulesView(rulesViewData: RulesViewController.ViewData) {
        navigationController.pushViewController(viewControllerFactory.createRulesViewController(rulesViewData: rulesViewData), animated: true)
    }
    
    func startNewGame(game: GameData.Games, players: [String]) {
        
    }
}
