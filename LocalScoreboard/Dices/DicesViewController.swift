//
//  DicesViewController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 03/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

protocol DicesViewControllerDelegate: class {
    func quitGame()
    func pushRulesView(rulesViewData: RulesViewController.ViewData)
}

class DicesViewController: BackgroundedUIViewController {
    private let disposeBag = DisposeBag()
    private var delegate: DicesViewControllerDelegate?
    private let viewModel: DicesViewModelInterface
    private let quitButton = UIButton.stickerButton(title: "global.quit".localized)
    private let rulesButton = UIButton.stickerButton(title: "global.fullRules".localized)
    
    init(delegate: DicesViewControllerDelegate, viewModel: DicesViewModelInterface) {
        self.delegate = delegate
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
    }
    
    private func layout() {
        view.addSubviews([quitButton, rulesButton])
        [quitButton, rulesButton].disableAutoresizingMask()
        
        [quitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         quitButton.widthAnchor.constraint(greaterThanOrEqualToConstant: ViewConstants.sheetMargin),
         quitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Values.navigationButtonTopPadding)].activate()
        
        [rulesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         rulesButton.widthAnchor.constraint(greaterThanOrEqualToConstant: ViewConstants.sheetMargin),
         rulesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
    }
    
    private func setupBindings() {
        quitButton.rx.tap
            .append(weak: self)
            .subscribe(onNext: { vc, _ in
                vc.delegate?.quitGame()
            }).disposed(by: disposeBag)
        
        rulesButton.rx.tap
            .append(weak: self)
            .subscribe(onNext: { vc, _ in
                vc.delegate?.pushRulesView(rulesViewData: GameData.forGame(.thousandDices).rulesViewData)
            }).disposed(by: disposeBag)
    }
}
