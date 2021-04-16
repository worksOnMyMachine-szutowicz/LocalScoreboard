//
//  UIPresentationController+BluredBackgroud.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 24/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class BlurredBackgroundUIPresentationController: UIPresentationController {
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        if let superview = presentingViewController.view {
            superview.addSubviewAndFill(blurView)
        }

        blurView.alpha = 0
        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.blurView.alpha = 1
        }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.blurView.alpha = 0
        }, completion: { [weak self] _ in
            self?.blurView.removeFromSuperview()
        })
    }
}
