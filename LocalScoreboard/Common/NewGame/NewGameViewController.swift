//
// Created by Krystian Szutowicz-EXT on 26/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

protocol NewGameViewControllerDelegate: class {
    func pushRulesView(rulesViewData: RulesViewController.ViewData)
    func startNewGame(game: GameData.Games, players: [String])
}

class NewGameViewController: BackgroundedUIViewController {
    typealias VMInput = NewGameViewModel.Input
    typealias VMOutput = NewGameViewModel.Output
    private let disposeBag = DisposeBag()
    private weak var delegate: NewGameViewControllerDelegate?
    private let viewModel: NewGameViewModelInterface
    private let gameHeaderView: GameHeaderView
    private let addPlayersView: AddPlayersView
    private let rulesButton = UIButton.stickerButton(title: "global.fullRules".localized)
    private let playButton = UIButton.stickerButton(title: "newGame.play".localized)

    init(delegate: NewGameViewControllerDelegate, viewModel: NewGameViewModelInterface) {
        self.delegate = delegate
        self.viewModel = viewModel
        self.gameHeaderView = .init(viewData: viewModel.viewData.gameHeaderViewData)
        self.addPlayersView = .init(viewModel: viewModel.viewData.addPlayersViewModel, viewFactory: NewGameViewFactory())
        
        super.init(nibName: nil, bundle: nil)
        
        setupBindigs()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        layout()
    }

    private func layout() {
        view.addSubviews([gameHeaderView, addPlayersView, rulesButton, playButton])
        [gameHeaderView, addPlayersView, rulesButton, playButton].disableAutoresizingMask()
        
        [gameHeaderView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         gameHeaderView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         gameHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Values.topMargin)].activate()
        
        [addPlayersView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         addPlayersView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         addPlayersView.topAnchor.constraint(equalTo: gameHeaderView.bottomAnchor, constant: ViewConstants.gridPadding)].activate()
        
        [rulesButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         rulesButton.widthAnchor.constraint(greaterThanOrEqualToConstant: ViewConstants.sheetMargin),
         rulesButton.topAnchor.constraint(equalTo: addPlayersView.bottomAnchor, constant: ViewConstants.gridPadding)].activate()
        
        [playButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         playButton.topAnchor.constraint(equalTo: rulesButton.bottomAnchor, constant: ViewConstants.gridPadding),
         playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
    }
    
    private func setupBindigs() {
        rulesButton.rx.tap
            .map { _ in VMInput.rulesButtonTapped(.init()) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        playButton.rx.tap
            .map { _ in VMInput.playButtonTapped(.init()) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable()
            .append(weak: self)
            .subscribe(onNext: { vc, output in
                switch output {
                case .showRulesView(let output):
                    vc.delegate?.pushRulesView(rulesViewData: output.rulesViewData)
                case .startNewGame(let output):
                    vc.delegate?.startNewGame(game: output.game, players: output.players)
                }
            }).disposed(by: disposeBag)
    }
}

extension NewGameViewController {
    private struct Values {
        static let playButtonFont: UIFont = .systemFont(ofSize: 25)
        static let topMargin: CGFloat = 60
    }
    
    struct ViewData {
        let gameHeaderViewData: GameHeaderView.ViewData
        let rulesViewData: RulesViewController.ViewData
        let addPlayersViewModel: AddPlayersViewModelInterface
    }
}
