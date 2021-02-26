//
//  Observable+Request.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 26/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

protocol Request {
    var requestData: Any { get }
}
typealias ResultHandler = (Any) -> Void

class ResultableRequest {
    let request: Request
    let resultHandler: ResultHandler?
    
    required init(request: Request, resultHandler: ResultHandler?) {
        self.request = request
        self.resultHandler = resultHandler
    }
}

protocol RequestableService {
    var request: PublishSubject<ResultableRequest> { get }
}

extension Observable {
    func withRequestResult<Output>(ofType: Output.Type, from service: RequestableService, with request: Request) -> Observable<Output> {
        flatMap { _ -> Observable<Any?> in
            let outputHandler = BehaviorSubject<Any?>(value: nil)
            let resultHandler: ResultHandler = { outputHandler.onNext($0) }
            service.request.onNext(.init(request: request, resultHandler: resultHandler))
            
            return outputHandler.asObservable()
        }.compactMap { $0 as? Output }
    }
    
    func doResultlessRequest(from service: RequestableService, _ request: @escaping (Element) -> Request) -> Observable<Element> {
        self.do { element in
            DispatchQueue.main.async {
                service.request.onNext(.init(request: request(element), resultHandler: nil))
            }
        }
    }
}
