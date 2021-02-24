//
//  InputAlertViewController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 15/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

protocol InputPopoverViewControllerDelegate: class {
    func showInputWarning(with viewData: DecisionAlertViewController.ViewData, on vc: UIViewController) -> Observable<DecisionAlertViewController.Decision>
}

class InputPopoverViewController: UIViewController, OutputableViewController, UIViewControllerTransitioningDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    typealias Output = Int?
    typealias VMInput = InputPopoverViewModelInput
    typealias VMOutput = InputPopoverViewModelOutput
    private let disposeBag = DisposeBag()
    private let viewModel: InputPopoverViewModelInterface
    private weak var delegate: InputPopoverViewControllerDelegate?
    private let titleLabel = UILabel()
    private let pickerView = UIPickerView()
    private let errorLabel = UILabel()
    private let cancelButton = UIButton.stickerButton(title: "global.cancel".localized)
    private let saveButton = UIButton.stickerButton(title: "global.save".localized)
    private var pickerSelections: [Int] {
        var selections: [Int] = []
        for i in 0..<viewModel.viewData.scoresSource.count {
            selections.append(pickerView.selectedRow(inComponent: i))
        }
        return selections
    }
    
    var outputSubject: PublishSubject<Output> = . init()

    init(viewModel: InputPopoverViewModelInterface, delegate: InputPopoverViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.backgroundColor = Colors.background
        view.layer.cornerRadius = Values.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleLabel.attributedText = .init(string: String(format: "inputPopover.title".localized, viewModel.viewData.playerName), attributes: ViewConstants.highlightedLabelAttributes)
        titleLabel.textAlignment = .center
        pickerView.delegate = self
        pickerView.dataSource = self
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        
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
        InputPopoverPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let containerView = UIView()
        let pickerLabel = UILabel()
        pickerLabel.attributedText = .init(string: viewModel.viewData.scoresSource[component][row], attributes: ViewConstants.highlightedLabelAttributes)
        pickerLabel.textAlignment = (component % 2) == 0 ? .right : .left
        
        containerView.addSubviewAndFill(pickerLabel, insets: .init(top: 0, left: Values.pickerItemPadding, bottom: 0, right: Values.pickerItemPadding))
        
        return containerView
    }
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        viewModel.viewData.scoresSource.count
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.viewData.scoresSource[component].count
    }
    
    private func layout() {
        view.addSubviews([titleLabel, pickerView, errorLabel, cancelButton, saveButton])
        [titleLabel, pickerView, errorLabel, cancelButton, saveButton].disableAutoresizingMask()
        
        [titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.labelPadding),
         titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.labelPadding),
         titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Values.labelPadding),
         titleLabel.heightAnchor.constraint(equalToConstant: Values.labelHeight)].activate()
        
        [pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         pickerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         pickerView.bottomAnchor.constraint(equalTo: errorLabel.topAnchor)].activate()
        
        [errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.labelPadding),
         errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.labelPadding),
         errorLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -Values.labelPadding),
         errorLabel.heightAnchor.constraint(equalToConstant: Values.errorLabelHeight)].activate()
        
        [cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
        
        [saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
    }
    
    private func setupBindings() {
        cancelButton.rx.tap
            .map { _ in VMInput.cancelButtonTapped(.init()) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .append(weak: self)
            .map { vc, _ in VMInput.saveButtonTapped(.init(selections: vc.pickerSelections)) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.FinishWithScoreModel.self)
            .map { $0.score }
            .bind(to: outputSubject)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.ShowWarningModel.self)
            .append(weak: self)
            .flatMapLatest { vc, output -> Observable<(DecisionAlertViewController.Decision, Int)> in
                vc.errorLabel.isHidden = true
                guard let delegate = vc.delegate else { return .empty() }
                
                let decision = delegate.showInputWarning(with: .init(title: "global.warning".localized, message: output.message, firstButton: .cancel, secondButton: .ok), on: vc)
                return Observable.zip(decision, Observable.just(output.score))
            }.filter { $0.0 == .ok }
            .map { $0.1 }
            .bind(to: outputSubject)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.ValidationErrorModel.self)
            .append(weak: self)
            .subscribe(onNext: { vc, output in
                vc.errorLabel.isHidden = false
                vc.errorLabel.attributedText = .init(string: output.message, attributes: ViewConstants.errorLabelAttributes)
            }).disposed(by: disposeBag)
    }
}

extension InputPopoverViewController {
    private struct Values {
        static let cornerRadius: CGFloat = 20
        static let labelPadding: CGFloat = 20
        static let labelHeight: CGFloat = 40
        static let errorLabelHeight: CGFloat = 60
        static let pickerItemPadding: CGFloat = 20
    }
    struct ViewData {
        let playerName: String
        let scoresSource: [[String]]
    }
}
