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
    private let viewData: ViewData
    private let disposeBag = DisposeBag()
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let firstButton: UIButton
    private let secondButton: UIButton
    private let verticalButtonsSeparator = UIView()
    private let horizontalButtonsSeparator = UIView()
    
    var outputSubject: PublishSubject<Output> = .init()
    
    init(viewData: ViewData) {
        self.viewData = viewData
        firstButton = UIButton.stickerButton(title: viewData.firstButton.localized)
        secondButton = UIButton.stickerButton(title: viewData.secondButton.localized)
        
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
        
        firstButton.layer.cornerRadius = Values.cornerRadius
        firstButton.layer.maskedCorners = .layerMinXMaxYCorner
        secondButton.layer.cornerRadius = Values.cornerRadius
        secondButton.layer.maskedCorners = .layerMaxXMaxYCorner
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
        view.addSubviews([titleLabel, messageLabel, firstButton, secondButton, verticalButtonsSeparator, horizontalButtonsSeparator])
        [titleLabel, messageLabel, firstButton, secondButton, verticalButtonsSeparator, horizontalButtonsSeparator].disableAutoresizingMask()
        
        [titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.labelPadding),
         titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.labelPadding),
         titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Values.labelPadding),
         titleLabel.heightAnchor.constraint(equalToConstant: Values.titleLabelHeight)].activate()
        
        [messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.labelPadding),
         messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.labelPadding),
         messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Values.labelPadding),
         messageLabel.bottomAnchor.constraint(equalTo: firstButton.topAnchor, constant: -Values.labelPadding)].activate()
        
        [firstButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         firstButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         firstButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
        
        [secondButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         secondButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         secondButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
        
        [verticalButtonsSeparator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
         verticalButtonsSeparator.widthAnchor.constraint(equalToConstant: Values.buttonBordersSize),
         verticalButtonsSeparator.topAnchor.constraint(equalTo: firstButton.topAnchor),
         verticalButtonsSeparator.bottomAnchor.constraint(equalTo: firstButton.bottomAnchor)].activate()
        
        [horizontalButtonsSeparator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         horizontalButtonsSeparator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         horizontalButtonsSeparator.centerYAnchor.constraint(equalTo: firstButton.topAnchor),
         horizontalButtonsSeparator.heightAnchor.constraint(equalToConstant: Values.buttonBordersSize)].activate()
    }
    
    private func setupBindings() {
        firstButton.rx.tap
            .append(weak: self)
            .map { vc, _ in vc.viewData.firstButton }
            .bind(to: outputSubject)
            .disposed(by: disposeBag)
            
        secondButton.rx.tap
            .append(weak: self)
            .map { vc, _ in vc.viewData.secondButton }
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
        case cancel
        case ok
        case quit
        
        var localized: String {
            "global.\(rawValue)".localized
        }
    }
    struct ViewData {
        let title: String
        let message: String
        let firstButton: Decision
        let secondButton: Decision
    }
}
