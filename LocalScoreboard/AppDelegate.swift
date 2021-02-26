//
//  AppDelegate.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 26/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinatorInterface?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        createAppCoordinator()
        return true
    }

    private func createAppCoordinator() {
        guard let window = window else { return }
        
        let navigationController = UINavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        DispatchQueue.main.async {
            Storage.start(completion: { [weak self] storage in
                guard let storage = storage else {
                    return
                }
                let storageService = StorageService(storage: storage)
                
                self?.appCoordinator = AppCoordinator(navigationController: navigationController, viewControllerFactory: AppCoordinatorFactory(storageService: storageService))
                
                self?.appCoordinator?.start()
            })
        }
    }
}
