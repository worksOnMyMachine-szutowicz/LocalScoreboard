//
//  DicesViewController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 03/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

protocol DicesViewControllerDelegate: DicesPlayerViewDelegate {
    func quitGameConfirmation() -> Observable<DecisionAlertViewController.Decision>
    func quitGame()
    func finishGame(winner: String) -> Observable<DecisionAlertViewController.Decision>
    func startNewGame(players: [String])
    func pushRulesView(rulesViewData: RulesViewController.ViewData)
}

class DicesViewController: BackgroundedUIViewController {
    typealias VMInput = DicesViewModelInput
    typealias VMOutput = DicesViewModelOutput
    private let viewModel: DicesViewModelInterface
    private let disposeBag = DisposeBag()
    private weak var delegate: DicesViewControllerDelegate?
    private let toolbarView: DicesToolbarView
    private let boardView: DicesBoardView
    private let quitButton = UIButton.navigationButton(title: "global.quit".localized)
    private let rulesButton = UIButton.navigationButton(title: "global.fullRules".localized)
    
    init(delegate: DicesViewControllerDelegate, viewModel: DicesViewModelInterface, viewFactory: DicesFactoryInterface) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.toolbarView = viewFactory.createToolbarView(viewModel: viewModel.viewData.toolbarViewModel)
        self.boardView = viewFactory.createBoardView(viewModel: viewModel.viewData.boardViewModel, delegate: delegate)
        
        super.init(nibName: nil, bundle: nil)
        
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        layout()
    }
    
    private func layout() {
        view.addSubviews([quitButton, boardView, toolbarView, rulesButton])
        [quitButton, boardView, toolbarView, rulesButton].disableAutoresizingMask()
        
        [quitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         quitButton.widthAnchor.constraint(greaterThanOrEqualToConstant: ViewConstants.defaultSheetMargin),
         quitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: Values.navigationButtonTopPadding)].activate()
        
        [boardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         boardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         boardView.topAnchor.constraint(equalTo: quitButton.bottomAnchor, constant: ViewConstants.gridPadding),
         boardView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor, constant: -ViewConstants.gridPadding)].activate()
        
        [toolbarView.leadingAnchor.constraint(equalTo: view.centerXAnchor),
         toolbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         toolbarView.bottomAnchor.constraint(equalTo: rulesButton.topAnchor)].activate()
        
        [rulesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         rulesButton.widthAnchor.constraint(greaterThanOrEqualToConstant: ViewConstants.defaultSheetMargin),
         rulesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
    }
    
    private func setupBindings() {
        quitButton.rx.tap
            .append(weak: self)
            .flatMap { vc, _ -> Observable<DecisionAlertViewController.Decision> in
                guard let delegate = vc.delegate else { return .empty() }
                
                return delegate.quitGameConfirmation()
            }.filter { $0 == .quit }
            .append(weak: self)
            .subscribe(onNext: { vc, _ in
                vc.delegate?.quitGame()
            }).disposed(by: disposeBag)
        
        rulesButton.rx.tap
            .append(weak: self)
            .subscribe(onNext: { vc, _ in
                vc.delegate?.pushRulesView(rulesViewData: GameData.forGame(.thousandDices).rulesViewData)
            }).disposed(by: disposeBag)
        
        let finishGameRequest =  viewModel.output.asObservable().filterByAssociatedType(VMOutput.FinishGameModel.self)
            .append(weak: self)
            .flatMapFirst { vc, output -> Observable<DecisionAlertViewController.Decision> in
                guard let delegate = vc.delegate else { return .empty() }
                
                return delegate.finishGame(winner: output.winner)
            }.share()
        
        finishGameRequest
            .filter { $0 == .quit }
            .append(weak: self)
            .subscribe(onNext: { vc, _ in
                vc.delegate?.quitGame()
            }).disposed(by: disposeBag)
        
        finishGameRequest
            .filter { $0 == .ok }
            .map { _ in VMInput.newGameDataRequest(.init()) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.StartNewGameModel.self)
            .append(weak: self)
            .subscribe(onNext: { vc, output in
                vc.delegate?.startNewGame(players: output.players)
            }).disposed(by: disposeBag)
    }
}

extension DicesViewController {
    struct ViewData {
        let boardViewModel: DicesBoardViewModelInterface
        let toolbarViewModel: DicesToolbarViewModelInterface
    }
}
