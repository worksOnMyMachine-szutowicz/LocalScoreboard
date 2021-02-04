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
    private let boardView = DicesBoardView()
    
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
        view.addSubviews([quitButton, boardView, rulesButton])
        [quitButton, boardView, rulesButton].disableAutoresizingMask()
        
        [quitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         quitButton.widthAnchor.constraint(greaterThanOrEqualToConstant: ViewConstants.sheetMargin),
         quitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Values.navigationButtonTopPadding)].activate()
        
        [boardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         boardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         boardView.topAnchor.constraint(equalTo: quitButton.bottomAnchor, constant: ViewConstants.verticalPadding),
         boardView.bottomAnchor.constraint(equalTo: rulesButton.topAnchor, constant: -ViewConstants.verticalPadding)].activate()
        
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
