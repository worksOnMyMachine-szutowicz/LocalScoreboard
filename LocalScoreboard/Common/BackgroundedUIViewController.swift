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
    
    override func viewDidLoad() {
        setSheetBackground()
    }
    
    override func viewDidLayoutSubviews() {
        adjustSafeAreaToGrid()
    }
    
    func setupBackButton() {
        let backButton = UIButton.stickerButton(title: "global.back".localized)
        backButton.rx.tap
            .append(weak: self)
            .subscribe(onNext: { vc, _ in
                vc.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    private func setSheetBackground() {
        setNavigationBarInvisible()
        
        let background = BackgroundView(for: view)
        view.addSubviewAndFill(background)
        view.sendSubviewToBack(background)
    }
    
    private func setNavigationBarInvisible() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func adjustSafeAreaToGrid() {
        let topInsetToFirstGrid = ViewConstants.backgroundGridSize - CGFloat(Int(view.safeAreaInsets.top) % Int(ViewConstants.backgroundGridSize))
        
        let bottomUncoveredSpace = CGFloat(Int(view.bounds.height) % Int(ViewConstants.backgroundGridSize))
        let bottomInsetToFirstGrid = ViewConstants.backgroundGridSize - CGFloat(Int(view.safeAreaInsets.bottom - bottomUncoveredSpace) % Int(ViewConstants.backgroundGridSize))
        
        if topInsetToFirstGrid < ViewConstants.backgroundGridSize {
            additionalSafeAreaInsets.top += topInsetToFirstGrid
        }
        if bottomInsetToFirstGrid < ViewConstants.backgroundGridSize {
            additionalSafeAreaInsets.bottom += bottomInsetToFirstGrid
        }
        viewSafeAreaInsetsDidChange()
    }
}
