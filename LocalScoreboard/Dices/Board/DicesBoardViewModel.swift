//
//  DicesBoardViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 22/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift

class DicesBoardViewModel: RxOutput<DicesBoardViewModelOutput>, DicesBoardViewModelInterface {
    var viewData: DicesBoardView.ViewData
    
    init(players: [String], storageService: StorageServiceInterface) {
        viewData = .init(players: players.map { DicesPlayerViewModel(viewData: .init(name: $0), storageService: storageService) })
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        Observable.merge(viewData.players.map { $0.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.PlayerWon.self) })
            .map { Output.finishGame(.init(winner: $0.playerName)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        for (raisingPlayerIndex, raisingPlayer) in viewData.players.enumerated() {
            for (stillPlayerIndex, stillPlayer) in viewData.players.enumerated() where stillPlayerIndex != raisingPlayerIndex {
                raisingPlayer.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.ScoreChangedModel.self)
                    .withLatestFrom(stillPlayer.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.ScoreChangedModel.self)) { (input: $0, output: $1.stepScore) }
                    .append(weak: self)
                    .filter { vm, data in
                        data.output >= 100 && vm.isOnePlayerSurpasingAnother(raisingPlayer: data.input, stillPlayer: data.output)
                    }.map { _ in DicesPlayerViewModelInput.playerSurpassed(.init()) }
                    .bind(to: stillPlayer.input)
                    .disposed(by: disposeBag)
            }
        }
    }
    
    private func isOnePlayerSurpasingAnother(raisingPlayer: DicesPlayerViewModelOutput.ScoreChangedModel, stillPlayer: Int) -> Bool {
        raisingPlayer.startedFrom < stillPlayer && stillPlayer.distance(to: raisingPlayer.stepScore) == 1
    }
}
