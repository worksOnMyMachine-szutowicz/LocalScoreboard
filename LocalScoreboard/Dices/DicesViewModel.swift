//
//  DicesViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 03/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class DicesViewModel: RxInputOutput<DicesViewModelInput, DicesViewModelOutput>, DicesViewModelInterface {
    var output: Driver<DicesViewModelOutput> {
        outputRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
    
    init(players: [String]) {
        
    }
}
