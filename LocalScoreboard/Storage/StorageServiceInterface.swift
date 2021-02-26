//
//  StorageServiceInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 26/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift

protocol StorageServiceInterface: RequestableService { }

enum StorageServiceRequest: Request {
    case saveScoreOccurrence(SaveScoreOccurrenceModel)
    case getTopScoresByOccurences(GetTopScoresByOccurrences)
    
    struct SaveScoreOccurrenceModel { let score: Int }
    struct GetTopScoresByOccurrences {
        let scoresToReturn: Int
    }
    
    var requestData: Any {
        switch self {
        case .saveScoreOccurrence(let associatedValue):
            return associatedValue
        case .getTopScoresByOccurences(let associatedValue):
            return associatedValue
        }
    }
}
