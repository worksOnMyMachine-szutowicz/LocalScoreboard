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
    
    init(players: [String]) {
        self.players = players
        viewData = .init(boardViewModel: DicesBoardViewModel(players: players))
        
        super.init()
        
        setupBindigs()
    }
    
    private func setupBindigs() {
        viewData.boardViewModel.output.asObservable().filterByAssociatedType(DicesBoardViewModelOutput.FinishGameModel.self)
            .map { Output.finishGame(.init(winner: $0.winner)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.NewGameDataRequest.self)
            .append(weak: self)
            .map { vm, _ in Output.startNewGame(.init(players: vm.players)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
