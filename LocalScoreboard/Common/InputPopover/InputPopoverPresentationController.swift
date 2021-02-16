//
//  InputAlertPresenter.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 16/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class InputPopoverPresentationController: UIPresentationController {
    private let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let bounds = presentingViewController.view.bounds
        let size = CGSize(width: bounds.width, height: Values.presentationHeight)
        let origin = CGPoint(x: 0, y: bounds.maxY - size.height)
        
        return CGRect(origin: origin, size: size)
    }

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

extension InputPopoverPresentationController {
    private struct Values {
        static let presentationHeight: CGFloat = 300
    }
}
