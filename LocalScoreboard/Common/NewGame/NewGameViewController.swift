//
// Created by Krystian Szutowicz-EXT on 26/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

protocol NewGameViewControllerDelegate: SeeFullRulesViewDelegate {
    func startNewGame(game: GameData.Games, players: [String])
}

class NewGameViewController: UIViewController {
    typealias VMInput = NewGameViewModel.Input
    typealias VMOutput = NewGameViewModel.Output
    private let disposeBag = DisposeBag()
    private weak var delegate: NewGameViewControllerDelegate?
    private let viewModel: NewGameViewModelInterface
    private let stackView = UIStackView(type: .verticalWithDefaultSpacing)
    private let playButton = UIButton(type: .system)

    init(delegate: NewGameViewControllerDelegate, viewModel: NewGameViewModelInterface) {
        self.delegate = delegate
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
        
        setupBindigs()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        setSheetBackground()
        title = "newGame.title".localized
        playButton.titleLabel?.font = Values.playButtonFont
        playButton.setTitle("newGame.play".localized, for: .normal)

        layout()
    }

    private func layout() {
        view.addSubviewAndFillToSafeArea(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(GameHeaderView(viewData: viewModel.viewData.gameHeaderViewData))
        stackView.addArrangedSubview(AddPlayersView(viewModel: viewModel.viewData.addPlayersViewModel, viewFactory: NewGameViewFactory()))
        stackView.addArrangedSubview(SeeFullRulesView(delegate: delegate, rulesViewData: viewModel.viewData.rulesViewData))
        stackView.addArrangedSubview(playButton)
    }
    
    private func setupBindigs() {
        playButton.rx.tap
            .map { _ in VMInput.playButtonTapped(.init()) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable()
            .append(weak: self)
            .subscribe(onNext: { vc, output in
                switch output {
                case .error(let output):
                    print(output)
                case .startNewGame(let output):
                    vc.delegate?.startNewGame(game: output.game, players: output.players)
                }
            }).disposed(by: disposeBag)
    }
}

extension NewGameViewController {
    private struct Values {
        static let playButtonFont: UIFont = .systemFont(ofSize: 25)
    }
    
    struct ViewData {
        let gameHeaderViewData: GameHeaderView.ViewData
        let rulesViewData: RulesViewController.ViewData
        let addPlayersViewModel: AddPlayersViewModelInterface
    }
}
