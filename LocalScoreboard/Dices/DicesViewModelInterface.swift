//
//  DicesViewModelInterface.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 03/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxCocoa

protocol DicesViewModelInterface {
    var input: PublishRelay<DicesViewModelInput> { get }
    var output: Driver<DicesViewModelOutput> { get }
}

enum DicesViewModelInput {
    
}

enum DicesViewModelOutput {
    
}
