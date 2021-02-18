//
//  UIViewController+RxOutputable.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 18/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift

protocol OutputableViewController: UIViewController {
    associatedtype Output
    var outputSubject: PublishSubject<Output> { get }
}

extension Reactive where Base: OutputableViewController {
    var output: Observable<Base.Output> {
        self.base.outputSubject
            .take(1)
            .append(weak: self.base)
            .do { vc, _ in vc.dismiss(animated: true, completion: nil) }
            .map { $0.1 }
            .asObservable()
    }
}
