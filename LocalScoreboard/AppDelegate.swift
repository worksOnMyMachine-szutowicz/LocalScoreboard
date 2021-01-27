//
//  AppDelegate.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 26/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinatorInterface?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        createAppCoordinator()
        appCoordinator?.start()
        return true
    }

    private func createAppCoordinator() {
        guard let window = window else { return }

        appCoordinator = AppCoordinator(window: window, navigationController: UINavigationController(), viewControllerFactory: ViewControllerFactory())
    }

}
