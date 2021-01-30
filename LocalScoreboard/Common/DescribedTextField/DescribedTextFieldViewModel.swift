//
//  DescribedTextFieldViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class DescribedTextFieldViewModel: RxInputOutput<DescribedTextFieldViewModelInput, DescribedTextFieldViewModelOutput>, DescribedTextFieldViewModelInterface {
    
    var output: Driver<DescribedTextFieldViewModelOutput>{
        outputRelay.asDriver(onErrorRecover: { Driver.just(Output.error($0)) })
    }
    
    var viewOutput: BehaviorRelay<String> = .init(value: "")
    var viewData: DescribedTextFieldView.ViewData
    
    init(labelText: String) {
        self.viewData = .init(labelText: labelText)
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.UpdateModel.self)
            .map { Output.updateView(.init(labelText: $0.labelText)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
