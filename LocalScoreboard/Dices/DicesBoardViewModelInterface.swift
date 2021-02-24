//
//  DicesBoardViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 22/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DicesBoardViewModelInterface {
    var output: Driver<DicesBoardViewModelOutput> { get}
    
    var viewData: DicesBoardView.ViewData { get }
}

enum DicesBoardViewModelOutput: EnumWithAssociatedValue {
    case finishGame(FinishGameModel)
    
    struct FinishGameModel { let winner: String }
    
    func associatedValue() -> Any {
        switch self {
        case .finishGame(let associatedValue):
            return associatedValue
        }
    }
}
