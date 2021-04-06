//
//  UIView+Background.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 01/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class BackgroundedUIViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private var backgroundView: BackgroundView?
    
    var backgroundOptions: BackgroundOptions {
        BackgroundOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        if isBackgroundRedrawRequired() {
            setSheetBackground()
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        adjustSafeAreaToGrid()
    }
    
    func setupBackButton() {
        let backButton = UIButton.stickerButton(title: "global.back".localized)
        backButton.rx.tap
            .append(weak: self)
            .subscribe(onNext: { vc, _ in
                vc.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        view.addSubview(backButton)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        [backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         backButton.widthAnchor.constraint(greaterThanOrEqualToConstant: ViewConstants.defaultSheetMargin),
         backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Values.navigationButtonTopPadding)].activate()
    }
    
    private func isBackgroundRedrawRequired() -> Bool {
        backgroundView?.bounds != view.bounds
    }
    
    private func setSheetBackground() {
        backgroundView?.removeFromSuperview()
        
        let backgroundView = BackgroundView(for: view, withMargin: backgroundOptions.margin)
        backgroundView.layer.cornerRadius = backgroundOptions.cornerRounding.value
        backgroundView.layer.maskedCorners = backgroundOptions.cornerRounding.corners
        
        self.backgroundView = backgroundView
        view.addSubviewAndFill(backgroundView)
        view.sendSubviewToBack(backgroundView)
    }
    
    private func adjustSafeAreaToGrid() {
        let topInsetToFirstGrid = ViewConstants.backgroundGridSize - CGFloat(Int(view.safeAreaInsets.top) % Int(ViewConstants.backgroundGridSize))
        
        let bottomUncoveredSpace = CGFloat(Int(view.bounds.height) % Int(ViewConstants.backgroundGridSize))
        let bottomInsetToFirstGrid = ViewConstants.backgroundGridSize - CGFloat(abs(Int(view.safeAreaInsets.bottom - bottomUncoveredSpace)) % Int(ViewConstants.backgroundGridSize))
        
        let rightUncoveredSpace = CGFloat(Int(view.bounds.width) % Int(ViewConstants.backgroundGridSize))
        let rightInsetToFirstGrid = ViewConstants.backgroundGridSize - CGFloat(abs(Int(view.safeAreaInsets.right - rightUncoveredSpace)) % Int(ViewConstants.backgroundGridSize))
        
        if topInsetToFirstGrid < ViewConstants.backgroundGridSize {
            additionalSafeAreaInsets.top += topInsetToFirstGrid
        }
        if bottomInsetToFirstGrid < ViewConstants.backgroundGridSize {
            additionalSafeAreaInsets.bottom += bottomInsetToFirstGrid
        }
        if rightInsetToFirstGrid < ViewConstants.backgroundGridSize {
            additionalSafeAreaInsets.right += rightInsetToFirstGrid
        }
    }
}

extension BackgroundedUIViewController {
    struct Values {
        static let navigationButtonTopPadding: CGFloat = 60
    }
    
    struct BackgroundOptions {
        let margin: CGFloat
        let cornerRounding: (value: CGFloat, corners: CACornerMask)
        
        init(margin: CGFloat = ViewConstants.defaultSheetMargin, cornerRounding: (value: CGFloat, corners: CACornerMask) = (0, [])) {
            self.margin = margin
            self.cornerRounding = cornerRounding
        }
    }
}
