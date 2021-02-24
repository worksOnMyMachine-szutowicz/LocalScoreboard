//
//  DecisionAlertPresentationController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 17/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DecisionAlertPresentationController: BlurredBackgroundUIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = UIScreen.main.bounds
        let size = CGSize(width: Values.width, height: Values.height)
        let origin = CGPoint(x: bounds.midX - 1/2 * Values.width, y: bounds.midY - 1/2 * Values.height)
        
        return CGRect(origin: origin, size: size)
    }
}

extension DecisionAlertPresentationController {
    private struct Values {
        static let width: CGFloat = 300
        static let height: CGFloat = 300
    }
}
