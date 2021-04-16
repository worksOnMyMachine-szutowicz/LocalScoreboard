//
//  DicesPlayerViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 08/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class DicesPlayerViewModel: RxInputOutput<DicesPlayerViewModelInput, DicesPlayerViewModelOutput>, DicesPlayerViewModelInterface {
    var viewData: DicesPlayerView.ViewData
    
    private let storageService: StorageServiceInterface
    private var gamePhase: GamePhase = .phaseOne
    private let score: BehaviorSubject<Int> = .init(value: 0)
    private let isCurrent: BehaviorSubject<Bool>
    private let playerIndex: Int
    
    private let phaseOneTax = 50
    private let surpassingTax = 100
    private let phaseTwoPunishment = -10
    
    init(viewData: DicesPlayerView.ViewData, playerIndex: Int, storageService: StorageServiceInterface) {
        self.viewData = viewData
        self.storageService = storageService
        self.isCurrent = .init(value: playerIndex == 0)
        self.playerIndex = playerIndex
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        Observable.merge(input.asObservable().filterByAssociatedType(Input.ViewDidLoadModel.self).mapToVoid(), isCurrent.mapToVoid())
            .withLatestFrom(isCurrent)
            .append(weak: self)
            .map { vm, isCurrent in isCurrent ? Output.becomedCurrentPlayer(.init(playerIndex: vm.playerIndex, gamePhase: vm.gamePhase)) : Output.resignedCurrentPlayer(.init()) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.CurrentPlayerModel.self)
            .map { $0.value }
            .bind(to: isCurrent)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.AddScoreTappedModel.self)
            .withRequestResult(ofType: [Int].self, from: storageService, with: StorageServiceRequest.getTopScoresByOccurences(.init(scoresToReturn: Values.quickDrawsCount)))
            .withLatestFrom(score) { (quickDraws: $0, currentScore: $1) }
            .append(weak: self)
            .map { vm, data in DicesInputPopoverViewModel(playerName: vm.viewData.name, gamePhase: vm.gamePhase, currentScore: data.currentScore, quickDraws: data.quickDraws) }
            .map { Output.showInputPopover(.init(inputPopoverViewModel: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        let punishment = input.asObservable().filterByAssociatedType(Input.PunishmentTappedModel.self)
            .append(weak: self)
            .map { vm, _ in (vm, vm.phaseTwoPunishment) }
            .doResultlessRequest(from: storageService) { StorageServiceRequest.saveScoreOccurrence(.init(score: $0.1)) }
        
        let addScore = input.asObservable().filterByAssociatedType(Input.AddScoreModel.self)
            .doResultlessRequest(from: storageService) { StorageServiceRequest.saveScoreOccurrence(.init(score: $0.score)) }
            .append(weak: self)
            .map { vm, input in (vm, vm.gamePhase == .phaseTwo ? input.score : input.score - vm.phaseOneTax) }
        
        let playerSurpassed = input.asObservable().filterByAssociatedType(Input.PlayerSurpassedModel.self)
            .append(weak: self)
            .map { vm, _ in (vm, -vm.surpassingTax) }
        
        let scoreUpdates = Observable.merge(addScore, punishment, playerSurpassed)
            .withLatestFrom(score) { ($0.0, $0.1, $1) }
            .map { vc, inputScore, currentScore -> [Output.ScoreChangedModel] in
                let newScore = currentScore + inputScore
                
                return Array(min(currentScore, newScore)...max(currentScore, newScore))
                    .sorted { abs($0.distance(to: currentScore)) < abs($1.distance(to: currentScore)) }
                    .map { Output.ScoreChangedModel(startedFrom: currentScore, stepScore: $0) }
            }.append(weak: self)
            .flatMapLatest { vc, stepOutput -> Observable<(Int, Output.ScoreChangedModel)> in
                let delayer = Observable<Int>.interval(.milliseconds(DicesScoreView.Values.animationTime.milisecondsValue), scheduler: MainScheduler.instance)
                let output =  Observable.range(start: 0, count: stepOutput.count)
                    .map { stepOutput[$0] }

                return Observable.zip(delayer, output)
            }.map { $0.1 }
            .share()

        scoreUpdates
            .map { $0.stepScore }
            .bind(to: score)
            .disposed(by: disposeBag)
        
        scoreUpdates
            .take(1)
            .append(weak: self)
            .subscribe(onNext: { vm, _ in
                vm.gamePhase = .phaseTwo
            }).disposed(by: disposeBag)

        scoreUpdates
            .map { Output.scoreChanged($0) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        scoreUpdates
            .filter { $0.stepScore == 1000 }
            .append(weak: self)
            .map { vm, _ in Output.playerWon(.init(playerName: vm.viewData.name)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}

extension DicesPlayerViewModel {
    enum GamePhase {
        case phaseOne
        case phaseTwo
    }
    private struct Values {
        static let quickDrawsCount = 5
    }
}

