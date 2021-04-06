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
    var viewData: NewGameViewController.ViewData
    private let gameData: GameData
    private let addPlayersViewModel: AddPlayersViewModelInterface
    
    init(gameData: GameData) {
        self.gameData = gameData
        addPlayersViewModel = AddPlayersViewModel(requiredPlayers: gameData.requiredPlayers)
        viewData = .init(gameHeaderViewData: gameData.gameHeaderViewData, rulesViewData: gameData.rulesViewData, addPlayersViewModel: addPlayersViewModel)
        
        super.init()
        
        setupBindigs()
    }
    
    private func setupBindigs() {
        input.asObservable().filterByAssociatedType(Input.RulesButtonTappedModel.self)
            .append(weak: self)
            .map { vm, _ in Output.showRulesView(.init(rulesViewData: vm.gameData.rulesViewData)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.PlayButtonTappedModel.self)
            .map { _ in AddPlayersViewModelInput.validate(.init()) }
            .bind(to: addPlayersViewModel.input)
            .disposed(by: disposeBag)
        
        addPlayersViewModel.output.asObservable().filterByAssociatedType(AddPlayersViewModelOutput.ValidationSuccessModel.self)
            .append(weak: self)
            .map { vm, output in Output.startNewGame(.init(game: vm.gameData.game, players: output.players)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
