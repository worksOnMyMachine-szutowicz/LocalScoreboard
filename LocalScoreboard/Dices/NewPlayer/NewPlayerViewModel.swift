//
//  NewPlayerViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class NewPlayerViewModel: RxInputOutput<NewPlayerViewModelInput, NewPlayerViewModelOutput>, NewPlayerViewModelInterface {
    var output: Driver<Output> {
        outputRelay.asDriver(onErrorRecover: { Driver.just(Output.error($0)) })
    }
    var viewData: NewPlayerView.ViewData
    
    private let describedTextFieldViewModel: DescribedTextFieldViewModelInterface
    
    init(index: Int, canBeDeleted: Bool) {
        describedTextFieldViewModel = DescribedTextFieldViewModel(labelText: String(format: "newGame.addPlayer.player".localized, String(index + 1)))
        viewData = .init(descibedTextFieldViewModel: describedTextFieldViewModel, canBeDeleted: canBeDeleted, index: index)
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.UpdateIndexModel.self)
            .append(weak: self)
            .do { vm, _ in vm.viewData.index -= 1 }
            .map { vm, _ in DescribedTextFieldViewModelInput.update(.init(labelText: String(format: "newGame.addPlayer.player".localized, String(vm.viewData.index + 1)))) }
            .bind(to: describedTextFieldViewModel.input)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.DeleteTappedModel.self)
            .append(weak: self)
            .map { vm, _ in Output.delete(.init(index: vm.viewData.index)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
