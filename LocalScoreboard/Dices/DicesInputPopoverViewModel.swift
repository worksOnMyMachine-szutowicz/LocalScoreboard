//
//  DicesInputPopoverViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 17/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

class DicesInputPopoverViewModel: RxInputOutput<InputPopoverViewModelInput, InputPopoverViewModelOutput>, InputPopoverViewModelBinder {
    var viewData: InputPopoverViewController.ViewData
    
    private let operations: [(description: String, operation: ((Int) -> Int))] = [("global.+".localized, { $0 }), ("global.-".localized, { -$0 })]
    private let data: [Int] = Array(stride(from: 5, to: 1000, by: 5))
    private let gamePhase: DicesPlayerViewModel.GamePhase
    private let currentScore: Int
    
    private let phaseOneTax = 50
    private let firstPassage = 301..<400
    private let secondPassage = 701..<800
    
    private let quickDraws: [Int]
    
    init(playerName: String, gamePhase: DicesPlayerViewModel.GamePhase, currentScore: Int, quickDraws: [Int]) {
        viewData = .init(playerName: playerName, scoresSource: [operations.map { $0.description }, data.map { String($0) }],
                         quickDrawsSource: quickDraws.map { String($0) })
        self.gamePhase = gamePhase
        self.currentScore = currentScore
        self.quickDraws = quickDraws
        
        super.init()
        setupBindigs()
    }
    
    func calculateScoreFor(selections: [Int]) -> Int {
        let operationSelection = selections[0]
        let dataSelection = selections[1]
        return operations[operationSelection].operation(data[dataSelection])
    }
    
    func calculateSelectionFor(quickDraw: Int) -> [Int] {
        let selection = quickDraws[quickDraw]
        let operationSelection = selection > 0 ? 0 : 1
        guard let dataSelection = data.firstIndex(of: abs(selection)) else { return [] }
        
        return [operationSelection, dataSelection]
    }
    
    func validate(score: Int) -> InputPopoverViewModelValidationResultModel {
        switch (gamePhase: gamePhase, currentScore: currentScore, score: score) {
            // .error
            case let scoreData where isPhaseOneError(gamePhase: scoreData.gamePhase, score: scoreData.score):
                return .init(resultType: .error, message: String(format: "1000dices.input.error.phaseOne".localized, arguments: [String(phaseOneTax)]))
            case let scoreData where isOnPassage(currentScore: scoreData.currentScore, score: scoreData.score):
                return .init(resultType: .error, message: "1000dices.input.error.passage".localized)
            case let scoreData where isSurplus(currentScore: scoreData.currentScore, score: scoreData.score):
                return .init(resultType: .error, message: "1000dices.input.error.surplus".localized)
                
            // .warning
            case let scoreData where isUnsafelyEnteringPassage(currentScore: scoreData.currentScore, score: scoreData.score):
                return .init(score: score, resultType: .warning, message: String(format: "1000dices.input.warning.passage".localized, arguments: [String(score), String((currentScore + score).distanceToNearestHundred)]))
        
            // .ok
            default:
                return .init(score: score, resultType: .ok, message: "")
        }
    }
    
    // .error
    private func isPhaseOneError(gamePhase: DicesPlayerViewModel.GamePhase, score: Int) -> Bool {
        gamePhase == .phaseOne && score < phaseOneTax
    }
    
    private func isOnPassage(currentScore: Int, score: Int) -> Bool {
        guard score > 0 else { return false }

        return firstPassage.contains(currentScore) && firstPassage.contains(currentScore + score) ||
            secondPassage.contains(currentScore) && secondPassage.contains(currentScore + score)
    }
    
    private func isSurplus(currentScore: Int, score: Int) -> Bool {
        currentScore + score > 1000
    }
    
    // .warning
    private func isUnsafelyEnteringPassage(currentScore: Int, score: Int) -> Bool {
        guard score > 0 else { return false }
        
        return firstPassage.firstHalf.contains(currentScore + score) ||
            secondPassage.firstHalf.contains(currentScore + score)
    }
}

private extension Range where Bound == Int {
    var firstHalf: Range<Int> {
        self[startIndex]..<(self[startIndex] + count/2)
    }
}

private extension Int {
    var distanceToNearestHundred: Int {
        100 - (self % 100)
    }
}
