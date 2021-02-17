//
//  DecisionAlertViewController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 17/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class DecisionAlertViewController: UIViewController, UIViewControllerTransitioningDelegate {
    private let disposeBag = DisposeBag()
    private let completion: ((Decision) -> Void)
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let cancelButton = UIButton.stickerButton(title: Decision.cancel.localized)
    private let okButton = UIButton.stickerButton(title: Decision.ok.localized)
    private let verticalButtonsSeparator = UIView()
    private let horizontalButtonsSeparator = UIView()
    
    private init(viewData: ViewData, completion: @escaping ((Decision) -> Void)) {
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.backgroundColor = Colors.background
        view.layer.cornerRadius = Values.cornerRadius
        titleLabel.attributedText = .init(string: viewData.title, attributes: ViewConstants.highlightedLabelAttributes)
        titleLabel.textAlignment = .center
        messageLabel.attributedText = .init(string: viewData.message, attributes: ViewConstants.labelAttributes)
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        cancelButton.layer.cornerRadius = Values.cornerRadius
        cancelButton.layer.maskedCorners = .layerMinXMaxYCorner
        okButton.layer.cornerRadius = Values.cornerRadius
        okButton.layer.maskedCorners = .layerMaxXMaxYCorner
        verticalButtonsSeparator.backgroundColor = Colors.backgroundLine
        horizontalButtonsSeparator.backgroundColor = Colors.backgroundLine
        
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        layout()
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        DecisionAlertPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    private func layout() {
        view.addSubviews([titleLabel, messageLabel, cancelButton, okButton, verticalButtonsSeparator, horizontalButtonsSeparator])
        [titleLabel, messageLabel, cancelButton, okButton, verticalButtonsSeparator, horizontalButtonsSeparator].disableAutoresizingMask()
        
        [titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.labelPadding),
         titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.labelPadding),
         titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Values.labelPadding),
         titleLabel.heightAnchor.constraint(equalToConstant: Values.titleLabelHeight)].activate()
        
        [messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.labelPadding),
         messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.labelPadding),
         messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Values.labelPadding),
         messageLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -Values.labelPadding)].activate()
        
        [cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         cancelButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
        
        [okButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         okButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         okButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
        
        [verticalButtonsSeparator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         verticalButtonsSeparator.widthAnchor.constraint(equalToConstant: Values.buttonBordersSize),
         verticalButtonsSeparator.topAnchor.constraint(equalTo: cancelButton.topAnchor),
         verticalButtonsSeparator.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor)].activate()
        
        [horizontalButtonsSeparator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         horizontalButtonsSeparator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         horizontalButtonsSeparator.centerYAnchor.constraint(equalTo: cancelButton.topAnchor),
         horizontalButtonsSeparator.heightAnchor.constraint(equalToConstant: Values.buttonBordersSize)].activate()
    }
    
    private func setupBindings() {
        cancelButton.rx.tap
            .append(weak: self)
            .subscribe(onNext: { vc, _ in vc.completion(.cancel) })
            .disposed(by: disposeBag)
            
        okButton.rx.tap
            .append(weak: self)
            .subscribe(onNext: { vc, _ in vc.completion(.ok) })
            .disposed(by: disposeBag)
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
            
            return Disposables.create { [weak controller] in
                controller?.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension DecisionAlertViewController {
    private struct Values {
        static let cornerRadius: CGFloat = 20
        static let labelPadding: CGFloat = 20
        static let titleLabelHeight: CGFloat = 40
        static let buttonBordersSize: CGFloat = 2
    }
    enum Decision: String {
        case ok
        case cancel
        
        var localized: String {
            "global.\(rawValue)".localized
        }
    }
    struct ViewData {
        let title: String
        let message: String
    }
}
