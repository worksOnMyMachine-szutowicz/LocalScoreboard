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
    case addScoreTapped(AddScoreTappedModel)
    case addScore(AddScoreModel)
    
    struct AddScoreTappedModel { }
    struct AddScoreModel { let score: Int }
    
    func associatedValue() -> Any {
        switch self {
        case .addScoreTapped(let associatedValue):
            return associatedValue
        case .addScore(let associatedValue):
            return associatedValue
        }
    }
}

enum DicesPlayerViewModelOutput: EnumWithAssociatedValue {
    case showInputPopover(ShowInputPopoverModel)
    case scoreChanged(ScoreChangedModel)
    
    struct ShowInputPopoverModel { let inputPopoverViewModel: InputPopoverViewModelInterface}
    struct ScoreChangedModel { let score: Int }
    
    func associatedValue() -> Any {
        switch self {
        case .showInputPopover(let associatedValue):
            return associatedValue
        case .scoreChanged(let associatedValue):
            return associatedValue
        }
    }
}
