//
//  DecisionAlertViewController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 17/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class DecisionAlertViewController: UIViewController, OutputableViewController, UIViewControllerTransitioningDelegate {
    typealias Output = Decision
    private let disposeBag = DisposeBag()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let cancelButton = UIButton.stickerButton(title: Decision.cancel.localized)
    private let okButton = UIButton.stickerButton(title: Decision.ok.localized)
    private let verticalButtonsSeparator = UIView()
    private let horizontalButtonsSeparator = UIView()
    
    var outputSubject: PublishSubject<Output> = .init()
    
    init(viewData: ViewData) {
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
            .map { _ in Decision.cancel }
            .bind(to: outputSubject)
            .disposed(by: disposeBag)
            
        okButton.rx.tap
            .map { _ in Decision.ok }
            .bind(to: outputSubject)
            .disposed(by: disposeBag)
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
