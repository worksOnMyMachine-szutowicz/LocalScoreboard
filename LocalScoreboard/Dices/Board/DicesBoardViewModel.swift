//
//  DicesBoardViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 22/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift

class DicesBoardViewModel: RxInputOutput<DicesBoardViewModelInput, DicesBoardViewModelOutput>, DicesBoardViewModelInterface {
    private var currentPlayer: (index: Int, interface: DicesPlayerViewModelInterface)?
    
    var viewData: DicesBoardView.ViewData
    
    init(players: [String], storageService: StorageServiceInterface) {
        viewData = .init(players: players.enumerated().map { DicesPlayerViewModel(viewData: .init(name: $0.element), playerIndex: $0.offset, storageService: storageService) })
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.ToolbarButtonTappedModel.self)
            .observe(on: MainScheduler.asyncInstance)
            .append(weak: self)
            .subscribe(onNext: { vm, input in
                switch input.type {
                case .next:
                    vm.designateNextPlayer()
                case .add:
                    vm.currentPlayer?.interface.input.accept(.addScoreTapped(.init()))
                case .punishment:
                    vm.currentPlayer?.interface.input.accept(.punishmentTapped(.init()))
                    vm.designateNextPlayer()
                default:
                    return
                }
            }).disposed(by: disposeBag)
        
        Observable.merge(viewData.players.map { $0.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.ScoreAddedModel.self) })
            .observe(on: MainScheduler.asyncInstance)
            .append(weak: self)
            .subscribe(onNext: { vm, _ in
                vm.designateNextPlayer()
            }).disposed(by: disposeBag)
        
        Observable.merge(viewData.players.map { $0.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.BecomedCurrentPlayerModel.self) })
            .append(weak: self)
            .do { vm, currentPlayer in
                vm.currentPlayer?.interface.input.accept(.currentPlayer(.init(value: false)))
                vm.currentPlayer = (index: currentPlayer.playerIndex, interface: vm.viewData.players[currentPlayer.playerIndex])
            }.map { vm, currenPlayer in Output.currentPlayerChanged(.init(gamePhase: currenPlayer.gamePhase)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        Observable.merge(viewData.players.map { $0.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.PlayerWon.self) })
            .map { Output.finishGame(.init(winner: $0.playerName)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        for (raisingPlayerIndex, raisingPlayer) in viewData.players.enumerated() {
            for (stillPlayerIndex, stillPlayer) in viewData.players.enumerated() where stillPlayerIndex != raisingPlayerIndex {
                let scoreChanges = raisingPlayer.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.ScoreChangedModel.self)
                    .withLatestFrom(stillPlayer.output.asObservable().filterByAssociatedType(DicesPlayerViewModelOutput.ScoreChangedModel.self)) { (raisingPlayer: $0, stillPlayer: $1.stepScore) }
                    .append(weak: self)
                    .share()
                
                scoreChanges
                    .observe(on: MainScheduler.asyncInstance)
                    .map { vm, data in vm.isOnePlayerThreateningAnother(threatened: data.raisingPlayer.stepScore, threatening: data.stillPlayer) }
                    .distinctUntilChanged()
                    .map { DicesPlayerViewModelInput.playerThreatened(.init(threatened: $0, by: stillPlayer.viewData.name)) }
                    .bind(to: raisingPlayer.input)
                    .disposed(by: disposeBag)
                    
                scoreChanges
                    .map { vm, data in vm.isOnePlayerThreateningAnother(threatened: data.stillPlayer, threatening: data.raisingPlayer.stepScore) }
                    .distinctUntilChanged()
                    .map { DicesPlayerViewModelInput.playerThreatened(.init(threatened: $0, by: raisingPlayer.viewData.name)) }
                    .bind(to: stillPlayer.input)
                    .disposed(by: disposeBag)
                    
                scoreChanges
                    .filter { vm, data in
                        data.stillPlayer >= 100 && vm.isOnePlayerSurpasingAnother(raisingPlayer: data.raisingPlayer, stillPlayer: data.stillPlayer)
                    }.map { _ in DicesPlayerViewModelInput.playerSurpassed(.init()) }
                    .bind(to: stillPlayer.input)
                    .disposed(by: disposeBag)
            }
        }
    }
    
    private func isOnePlayerThreateningAnother(threatened: Int, threatening: Int) -> Bool {
        let dangerZone = 1...50
        
        return threatened >= 100 && dangerZone.contains(threatened - threatening)
    }
    
    private func isOnePlayerSurpasingAnother(raisingPlayer: DicesPlayerViewModelOutput.ScoreChangedModel, stillPlayer: Int) -> Bool {
        raisingPlayer.startedFrom < stillPlayer && stillPlayer.distance(to: raisingPlayer.stepScore) == 1
    }
    
    private func designateNextPlayer() {
        guard let currentPlayerIndex = currentPlayer?.index else { return }
        let nextPlayer = viewData.players.indices.contains(currentPlayerIndex + 1) ? currentPlayerIndex + 1 : 0
        viewData.players[nextPlayer].input.accept(.currentPlayer(.init(value: true)))
    }
}
