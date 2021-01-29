//
//  Observable+Weak.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift

extension ObservableType {
    func append<A: AnyObject>(weak obj: A) -> Observable<(A, Element)> {
        return flatMap { [weak obj] value -> Observable<(A, Element)> in
            guard let obj = obj else { return .empty() }
            return Observable.just((obj, value))
        }
    }
}
