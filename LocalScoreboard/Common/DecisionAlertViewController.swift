//
//  DecisionAlertViewController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 17/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class DecisionAlertViewController: UIAlertController {
    enum Decision: String {
        case ok
        case cancel
        
        var localized: String {
            "global.\(rawValue)".localized
        }
    }
    
    convenience init(viewData: ViewData, completion: @escaping ((Decision) -> Void)) {
        self.init(title: viewData.title, message: viewData.message, preferredStyle: .alert)
        
        addAction(UIAlertAction(title: Decision.ok.localized, style: .default) { _ in completion(.ok) })
        addAction(UIAlertAction(title: Decision.cancel.localized, style: .cancel) { _ in completion(.cancel) })
    }
}

extension DecisionAlertViewController {
    static func showAlertInController(with viewData: ViewData, in controller: UIViewController) -> Observable<Decision> {
        return Observable.create { [weak controller] observer in
            let alertController = DecisionAlertViewController(viewData: viewData, completion: { decision in
                observer.onNext(decision)
                observer.onCompleted()
            })

            controller?.present(alertController, animated: true, completion: nil)
            
            return Disposables.create { [weak alertController] in
                alertController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension DecisionAlertViewController {
    struct ViewData {
        let title: String
        let message: String
    }
}
