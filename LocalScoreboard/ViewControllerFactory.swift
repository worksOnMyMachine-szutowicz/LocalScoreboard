//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

protocol ViewControllerFactoryProtocol {
    func createNewGameViewController() -> UIViewController
}

class ViewControllerFactory: ViewControllerFactoryProtocol {
    func createNewGameViewController() -> UIViewController {
        NewGameViewController()
    }
}