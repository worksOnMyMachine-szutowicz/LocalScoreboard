//
//  AddPlayersViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol AddPlayersViewModelInterface {
    var input: PublishRelay<AddPlayersViewModelInput> { get }
    var output: Driver<AddPlayersViewModelOutput> { get }
}

enum AddPlayersViewModelInput: EnumWithAssociatedValue {
    //internal
    case addRequiredPlayers(AddRequiredPlayersModel)
    
    //external
    case addPlayerTapped(AddPlayerTappedModel)
    case validate(ValidateModel)
    
    struct AddRequiredPlayersModel { }
    struct AddPlayerTappedModel { }
    struct ValidateModel { }
    
    func associatedValue() -> Any {
        switch self {
        case .addRequiredPlayers(let associatedValue):
            return associatedValue
        case .addPlayerTapped(let associatedValue):
            return associatedValue
        case .validate(let associatedValue):
            return associatedValue
        }
    }
}

enum AddPlayersViewModelOutput: EnumWithAssociatedValue {
    case error(Error)
    
    //internal
    case addPlayer(AddPlayerModel)
    case deletePlayer(DeletePlayerModel)
    
    //external
    case validationSuccess(ValidationSuccessModel)
    
    struct AddPlayerModel { let newPlayerViewModel: NewPlayerViewModel }
    struct DeletePlayerModel { let index: Int }
    struct ValidationSuccessModel { let players: [String] }
    
    func associatedValue() -> Any {
        switch self {
        case .error(let associatedValue):
            return associatedValue
        case .addPlayer(let associatedValue):
            return associatedValue
        case .deletePlayer(let associatedValue):
            return associatedValue
        case .validationSuccess(let associatedValue):
            return associatedValue
        }
    }
}
