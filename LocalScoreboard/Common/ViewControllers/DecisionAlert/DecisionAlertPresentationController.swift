//
//  DecisionAlertPresentationController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 17/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import Lottie

class DecisionAlertPresentationController: BlurredBackgroundUIPresentationController {
    private var animationView: AnimationView?
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = UIScreen.main.bounds
        let size = CGSize(width: Values.width, height: Values.height)
        let origin = CGPoint(x: bounds.midX - 1/2 * Values.width, y: bounds.midY - 1/2 * Values.height)
        
        return CGRect(origin: origin, size: size)
    }
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, animation: Animations?) {
        if let animation = animation {
            animationView = .init(name: animation.rawValue)
            animationView?.loopMode = .loop
        }
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if let superview = presentingViewController.view, let animationView = animationView {
            superview.addSubviewAndFill(animationView)
            animationView.play()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.animationView?.alpha = 0
        }, completion: { [weak self] _ in
            self?.animationView?.removeFromSuperview()
            self?.animationView?.stop()
        })
    }
}

extension DecisionAlertPresentationController {
    private struct Values {
        static let width: CGFloat = 300
        static let height: CGFloat = 300
    }
}
