//
//  UIView+Background.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 01/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

extension UIViewController {
    func setSheetBackground() {
        navigationController?.navigationBar.barTintColor = Colors.background
        
        let viewHeight = view.bounds.height - (navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        let bounds = CGRect(x: 0, y: 0, width: view.bounds.width, height: viewHeight)
        let background = BackgroundView(for: bounds)
        view.addSubviewAndFill(background)
        view.sendSubviewToBack(background)
    }
}
