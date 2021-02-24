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
    
    private var gamePhase: GamePhase = .phaseOne
    private var score: BehaviorSubject<Int> = .init(value: 0)
    
    init(viewData: DicesPlayerView.ViewData) {
        self.viewData = viewData
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.AddScoreTappedModel.self)
            .withLatestFrom(score)
            .append(weak: self)
            .map { vm, currentScore in DicesInputPopoverViewModel(playerName: vm.viewData.name, gamePhase: vm.gamePhase, currentScore: currentScore) }
            .map { Output.showInputPopover(.init(inputPopoverViewModel: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        let scoreUpdates = input.asObservable().filterByAssociatedType(Input.AddScoreModel.self)
            .append(weak: self)
            .withLatestFrom(score) { ($0.0, $0.1, $1) }
            .map { vc, input, currentScore -> [Output.ScoreChangedModel] in
                let newScore = currentScore + input.score
                
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
}

