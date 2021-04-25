//
//  DicesPlayerStatusViewInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 25/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DicesPlayerStatusViewInterface {
    var input: PublishRelay<DicesPlayerStatusViewInput> { get }
}

enum DicesPlayerStatusViewInput: EnumWithAssociatedValue {
    case addStatus(AddStatusModel)
    
    struct AddStatusModel {
        let status: DicesPlayerStatusView.Statuses
        let duration: Double?
    }
    
    var associatedValue: Any {
        switch self {
        case .addStatus(let associatedValue):
            return associatedValue
        }
    }
}
