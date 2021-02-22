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
    var output: Driver<Output>{
        outputRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
    var viewData: DicesPlayerView.ViewData
    
    private var gamePhase: GamePhase = .phaseOne
    private var score: Int = 0
    
    init(viewData: DicesPlayerView.ViewData) {
        self.viewData = viewData
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.AddScoreTappedModel.self)
            .append(weak: self)
            .map { vm, _ in DicesInputPopoverViewModel(playerName: vm.viewData.name, gamePhase: vm.gamePhase, currentScore: vm.score) }
            .map { Output.showInputPopover(.init(inputPopoverViewModel: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.AddScoreModel.self)
            .append(weak: self)
            .map { vc, input -> [Output] in
                let newScore = vc.score + input.score
                let stepScores = Array(min(vc.score, newScore)...max(vc.score, newScore))
                    .sorted { abs($0.distance(to: vc.score)) < abs($1.distance(to: vc.score)) }
                    .map { Output.scoreChanged(.init(score: $0)) }
                
                vc.score = newScore
                vc.gamePhase = .phaseTwo
                return stepScores
            }
            .append(weak: self)
            .flatMapLatest { vc, stepOutput -> Observable<(Int, DicesPlayerViewModel.Output)> in
                let delayer = Observable<Int>.interval(.milliseconds(DicesScoreView.Values.animationTime.milisecondsValue), scheduler: MainScheduler.instance)
                let output =  Observable.range(start: 0, count: stepOutput.count)
                    .map { stepOutput[$0] }
                
                return Observable.zip(delayer, output)
            }.map { $0.1 }
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

