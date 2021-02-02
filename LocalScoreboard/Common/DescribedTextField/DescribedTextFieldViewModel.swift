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
    
    var output: Driver<Output>{
        outputRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
    var viewData: DescribedTextFieldView.ViewData
    private let userInput: BehaviorRelay<String> = .init(value: "")
    
    init(labelText: String) {
        self.viewData = .init(labelText: labelText)
        
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.UserInput.self)
            .map { $0.input }
            .bind(to: userInput)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.UpdateModel.self)
            .map { Output.updateView(.init(labelText: $0.labelText)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.ValidateModel.self)
            .withLatestFrom(userInput)
            .map { Output.validationResult(.init(result: !$0.isEmpty, userInput: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}
