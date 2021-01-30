//
// Created by Krystian Szutowicz-EXT on 26/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

protocol NewGameViewControllerDelegate: SeeFullRulesViewDelegate { }

class NewGameViewController: UIViewController {
    private weak var delegate: NewGameViewControllerDelegate?
    private let formView = UIStackView(type: .verticalWithDefaultSpacing)
    private let playButton = UIButton(type: .system)

    init(delegate: NewGameViewControllerDelegate?) {
        self.delegate = delegate
        
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

        formView.addArrangedSubview(GameHeaderView(title: "1000 Dices", description: "quite long text quite long text quite long text quite long text quite long text quite long text quite long text quite long text quite long text "))
        formView.addArrangedSubview(SeeFullRulesView(delegate: delegate))
        formView.addArrangedSubview(AddPlayersView(viewModel: AddPlayersViewModel(requiredPlayers: 2), viewFactory: NewGameViewFactory()))
        formView.addArrangedSubview(playButton)
    }
}

extension NewGameViewController {
    struct Values {
        static let playButtonFont: UIFont = .systemFont(ofSize: 25)
    }
}
