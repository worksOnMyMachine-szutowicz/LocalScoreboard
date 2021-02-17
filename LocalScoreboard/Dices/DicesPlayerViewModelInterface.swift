//
//  DicesPlayerViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 08/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DicesPlayerViewModelInterface {
    var input: PublishRelay<DicesPlayerViewModelInput> { get }
    var output: Driver<DicesPlayerViewModelOutput> { get }
    
    var viewData: DicesPlayerView.ViewData { get }
}

enum DicesPlayerViewModelInput: EnumWithAssociatedValue {
    case addScore(AddScoreModel)
    
    struct AddScoreModel { let score: Int }
    
    func associatedValue() -> Any {
        switch self {
        case .addScore(let associatedValue):
            return associatedValue
        }
    }
}

enum DicesPlayerViewModelOutput: EnumWithAssociatedValue {
    case scoreChanged(ScoreChangedModel)
    
    struct ScoreChangedModel { let score: Int }
    
    func associatedValue() -> Any {
        switch self {
        case .scoreChanged(let associatedValue):
            return associatedValue
        }
    }
}
