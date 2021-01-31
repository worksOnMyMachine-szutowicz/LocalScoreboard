//
//  NewGameViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 31/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class NewGameViewModel: RxInputOutput<NewGameViewModelInput, NewGameViewModelOutput>, NewGameViewModelInterface {
    var output: Driver<Output>{
        outputRelay.asDriver(onErrorRecover: { Driver.just(Output.error($0)) })
    }
    var viewData: NewGameViewController.ViewData
    private let game: GameData.Games
    private let addPlayersViewModel: AddPlayersViewModelInterface
    
    init(gameData: GameData) {
        game = gameData.game
        addPlayersViewModel = AddPlayersViewModel(requiredPlayers: gameData.requiredPlayers)
        viewData = .init(gameHeaderViewData: gameData.gameHeaderViewData, rulesViewData: gameData.rulesViewData, addPlayersViewModel: addPlayersViewModel)
        
        super.init()
        
        setupBindigs()
    }
    
    private func setupBindigs() {
        input.asObservable().filterByAssociatedType(Input.PlayButtonTappedModel.self)
            .map { _ in AddPlayersViewModelInput.validate(.init()) }
            .bind(to: addPlayersViewModel.input)
            .disposed(by: disposeBag)
        
        addPlayersViewModel.output.asObservable().filterByAssociatedType(AddPlayersViewModelOutput.ValidationSuccessModel.self)
            .append(weak: self)
            .map { vm, output in Output.startNewGame(.init(game: vm.game, players: output.players)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
