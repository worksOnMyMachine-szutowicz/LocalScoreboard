//
//  InputPopoverViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 16/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

protocol InputPopoverViewModelInterface {
    var viewData: InputPopoverViewController.ViewData { get }
    func calculateScoreFor(operationSelection: Int, dataSelection: Int) -> Int
}

class InputPopoverViewModel: InputPopoverViewModelInterface {
    private let operations: [(description: String, operation: ((Int) -> Int))]
    private let data: [Int]
    
    var viewData: InputPopoverViewController.ViewData
    
    init(playerName: String, operations: [(description: String, operation: ((Int) -> Int))], data: [Int]) {
        self.operations = operations
        self.data = data
        viewData = .init(playerName: playerName, scoresSource: [operations.map { $0.description }, data.map { String($0) }])
    }
    
    func calculateScoreFor(operationSelection: Int, dataSelection: Int) -> Int {
        operations[operationSelection].operation(data[dataSelection])
    }
}

extension InputPopoverViewModel {
    static func forDices(player: String) -> InputPopoverViewModel {
        let operations: [(description: String, operation: ((Int) -> Int))] = [("global.+".localized, { $0 }), ("global.-".localized, { -$0 })]
        let data = Array(stride(from: 0, to: 1000, by: 5))
        return .init(playerName: player, operations: operations, data: data)
    }
}
