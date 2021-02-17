//
//  DicesInputPopoverViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 17/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

class DicesInputPopoverViewModel: RxInputOutput<InputPopoverViewModelInput, InputPopoverViewModelOutput>, InputPopoverViewModelBinder {
    var output: Driver<Output>{
        outputRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
    var viewData: InputPopoverViewController.ViewData
    
    private let operations: [(description: String, operation: ((Int) -> Int))] = [("global.+".localized, { $0 }), ("global.-".localized, { -$0 })]
    private let data: [Int] = Array(stride(from: 5, to: 1000, by: 5))
    
    init(playerName: String) {
        viewData = .init(playerName: playerName, scoresSource: [operations.map { $0.description }, data.map { String($0) }])
        
        super.init()
        setupBindigs()
    }
    
    func calculateScoreFor(selections: [Int]) -> Int {
        let operationSelection = selections[0]
        let dataSelection = selections[1]
        return operations[operationSelection].operation(data[dataSelection])
    }
}
