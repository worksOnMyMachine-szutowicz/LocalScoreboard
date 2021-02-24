//
//  InputAlertPresenter.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 16/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class InputPopoverPresentationController: BlurredBackgroundUIPresentationController {
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: bounds.width, height: bounds.height * Values.heightMultiplier)
        let origin = CGPoint(x: 0, y: bounds.maxY - size.height)
        
        return CGRect(origin: origin, size: size)
    }
}

extension InputPopoverPresentationController {
    private struct Values {
        static let heightMultiplier: CGFloat = 0.5
    }
}
