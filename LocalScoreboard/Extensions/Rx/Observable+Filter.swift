//
//  File.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift


public extension Observable {
    func filterByCast<T>(_: T.Type) -> Observable<T> {
        filter { $0 is T }.map { $0 as! T }
    }
}

extension Observable where Element: EnumWithAssociatedValue {
    func filterByAssociatedType<T>(_: T.Type) -> Observable<T> {
        map { $0.associatedValue }.filterByCast(T.self)
    }
}

extension Observable where Element: ResultableRequest {
    func filterByRequestType<T>(_: T.Type) -> Observable<(request: T, resultHandler: ResultHandler?)> {
        filter { $0.request.requestData is T }
            .map { (request: $0.request.requestData as! T, resultHandler: $0.resultHandler) }
    }
}
