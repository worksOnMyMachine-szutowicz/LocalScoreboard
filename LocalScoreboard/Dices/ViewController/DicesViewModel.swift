//
//  DicesViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 23/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class DicesViewModel: RxInputOutput<DicesViewModelInput, DicesViewModelOutput>, DicesViewModelInterface {
    var viewData: DicesViewController.ViewData
    
    private let players: [String]
    
    init(players: [String], storageService: StorageServiceInterface) {
        self.players = players
        viewData = .init(boardViewModel: DicesBoardViewModel(players: players, storageService: storageService), toolbarViewModel: DicesToolbarViewModel())
        
        super.init()
        
        setupBindigs()
    }
    
    private func setupBindigs() {
        viewData.boardViewModel.output.asObservable().filterByAssociatedType(DicesBoardViewModelOutput.CurrentPlayerChangedModel.self)
            .map { DicesToolbarViewModelInput.refresh(.init(gamePhase: $0.gamePhase)) }
            .bind(to: viewData.toolbarViewModel.input)
            .disposed(by: disposeBag)
        
        viewData.boardViewModel.output.asObservable().filterByAssociatedType(DicesBoardViewModelOutput.FinishGameModel.self)
            .map { Output.finishGame(.init(winner: $0.winner)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        viewData.toolbarViewModel.output.asObservable()
            .map { DicesBoardViewModelInput.toolbarButtonTapped(.init(type: $0)) }
            .bind(to: viewData.boardViewModel.input)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.NewGameDataRequest.self)
            .append(weak: self)
            .map { vm, _ in Output.startNewGame(.init(players: vm.players)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
