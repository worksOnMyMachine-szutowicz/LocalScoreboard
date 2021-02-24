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
        
        setupBlurView()

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
    
    private func setupBlurView() {
        blurView.translatesAutoresizingMaskIntoConstraints = false
        
        if let superview = presentingViewController.view {
            superview.addSubview(blurView)
            [blurView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
             blurView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
             blurView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
             blurView.topAnchor.constraint(equalTo: superview.topAnchor)].activate()
        }
    }
}
