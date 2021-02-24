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
    
    init(players: [String]) {
        viewData = .init(players: players.map { DicesPlayerViewModel(viewData: .init(name: $0)) })
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        Observable.merge(viewData.players.map { $0.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.PlayerWon.self) })
            .map { Output.finishGame(.init(winner: $0.playerName)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
