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
    
    private var score: Int = 0
    
    init(viewData: DicesPlayerView.ViewData) {
        self.viewData = viewData
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.AddScoreModel.self)
            .append(weak: self)
            .do { vm, input in vm.score += input.score }
            .map { vm, input in Output.scoreChanged(.init(score: vm.score)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
