//
//  AnimatedButtonInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 06/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol AnimatedButtonInterface {
    var input: PublishRelay<AnimatedButtonInput> { get }
    var output: Driver<AnimatedButtonOutput> { get }
}

enum AnimatedButtonInput: EnumWithAssociatedValue {
    case animate(AnimateModel)
    case stopAnimating(StopAnimatingModel)
    
    struct AnimateModel { }
    struct StopAnimatingModel { }
    
    var associatedValue: Any {
        switch self {
        case .animate(let associatedValue):
            return associatedValue
        case .stopAnimating(let associatedValue):
            return associatedValue
        }
    }
}

enum AnimatedButtonOutput: EnumWithAssociatedValue {
    case tapped(TappedModel)
    
    struct TappedModel { }
    
    var associatedValue: Any {
        switch self {
        case .tapped(let associatedValue):
            return associatedValue
        }
    }
}
