//
//  RxInputOutput.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class RxInputOutput<I, O> {
    typealias Input = I
    typealias Output = O
    let disposeBag = DisposeBag()

    let input = PublishRelay<I>()
    let outputRelay = PublishRelay<O>()
    var output: Driver<Output> {
        outputRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
}

class RxOutput<O> {
    typealias Output = O
    let disposeBag = DisposeBag()

    let outputRelay = PublishRelay<O>()
    var output: Driver<Output> {
        outputRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
}

class RxRequestable<R> {
    typealias Request = R
    let disposeBag = DisposeBag()
    
    let request = PublishSubject<ResultableRequest>()
}
