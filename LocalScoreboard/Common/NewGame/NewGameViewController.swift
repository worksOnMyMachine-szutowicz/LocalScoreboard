//
// Created by Krystian Szutowicz-EXT on 26/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

protocol NewGameViewControllerDelegate: SeeFullRulesViewDelegate { }

class NewGameViewController: UIViewController {
    private weak var delegate: NewGameViewControllerDelegate?
    private let gameData: GameData
    private let formView = UIStackView(type: .verticalWithDefaultSpacing)
    private let playButton = UIButton(type: .system)

    init(delegate: NewGameViewControllerDelegate, gameData: GameData) {
        self.delegate = delegate
        self.gameData = gameData
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        view.backgroundColor = .systemGroupedBackground
        title = "newGame.title".localized
        playButton.titleLabel?.font = Values.playButtonFont
        playButton.setTitle("newGame.play".localized, for: .normal)

        layout()
    }

    private func layout() {
        view.addSubviewAndFillToSafeArea(formView)
        formView.translatesAutoresizingMaskIntoConstraints = false

        formView.addArrangedSubview(GameHeaderView(viewData: gameData.gameHeaderViewData))
        formView.addArrangedSubview(SeeFullRulesView(delegate: delegate, gameData: gameData))
        formView.addArrangedSubview(AddPlayersView(viewModel: AddPlayersViewModel(requiredPlayers: gameData.requiredPlayers), viewFactory: NewGameViewFactory()))
        formView.addArrangedSubview(playButton)
    }
}

extension NewGameViewController {
    private struct Values {
        static let playButtonFont: UIFont = .systemFont(ofSize: 25)
    }
}
