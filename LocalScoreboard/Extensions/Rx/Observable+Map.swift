//
//  Observable+Map.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 16/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift

public extension Observable {
    func mapToVoid() -> Observable<Void> {
        map { _ in return }
    }
    
    func mapTo(bool: Bool) -> Observable<Bool> {
        map { _ in return bool }
    }
}
