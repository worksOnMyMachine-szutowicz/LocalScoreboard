//
//  File.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift


public extension Observable {
    func filterByCast<T>(_ : T.Type) -> Observable<T> {
        return self.filter { $0 is T }.map { $0 as! T }
    }
}

extension Observable where Element: EnumWithAssociatedValue {
    func filterByAssociatedType<T>(_ : T.Type) -> Observable<T> {
        self.map { $0.associatedValue() }.filterByCast(T.self)
    }
}
