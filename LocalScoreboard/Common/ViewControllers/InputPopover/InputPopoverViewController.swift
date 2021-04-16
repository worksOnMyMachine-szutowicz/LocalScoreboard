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

class InputPopoverViewController: BackgroundedUIViewController, OutputableViewController, UIViewControllerTransitioningDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    typealias Output = Int?
    typealias VMInput = InputPopoverViewModelInput
    typealias VMOutput = InputPopoverViewModelOutput
    private let disposeBag = DisposeBag()
    private let viewModel: InputPopoverViewModelInterface
    private weak var delegate: InputPopoverViewControllerDelegate?
    private let titleLabel = UILabel()
    private let quickDrawsLabel = UILabel()
    private let quickDraws: [UIButton]
    private let selectionContainer = UIView()
    private let selectionLabel = UILabel()
    private let pickerView = UIPickerView()
    private let errorLabel = UILabel()
    private let quickDrawsStackView = UIStackView(type: .verticalWithoutSpacing)
    private let cancelButton = UIButton.navigationButton(title: "global.cancel".localized)
    private let saveButton = UIButton.navigationButton(title: "global.save".localized)
    private var pickerSelections: [Int] {
        var selections: [Int] = []
        for i in 0..<viewModel.viewData.scoresSource.count {
            selections.append(pickerView.selectedRow(inComponent: i))
        }
        return selections
    }
    
    override var backgroundOptions: BackgroundedUIViewController.BackgroundOptions {
        .init(margin: Values.quickDrawsWidth, cornerRounding: Values.cornerRounding)
    }
    
    var outputSubject: PublishSubject<Output> = .init()

    init(viewModel: InputPopoverViewModelInterface, delegate: InputPopoverViewControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.quickDraws = viewModel.viewData.quickDrawsSource.map { UIButton.quickDraw(title: $0) }
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.backgroundColor = Colors.background
        view.layer.cornerRadius = Values.cornerRounding.value
        view.layer.maskedCorners = Values.cornerRounding.corners
        titleLabel.attributedText = .init(string: String(format: "inputPopover.title".localized, viewModel.viewData.playerName), attributes: ViewConstants.highlightedLabelAttributes)
        titleLabel.textAlignment = .center
        quickDrawsLabel.attributedText = .init(string: "inputPopover.quickDraws".localized, attributes: ViewConstants.labelAttributes)
        quickDrawsLabel.textAlignment = .center
        quickDrawsStackView.spacing = Values.quickDrawsSpacing
        quickDrawsStackView.backgroundColor = Colors.background
        selectionLabel.attributedText = .init(string: "inputPopover.selection".localized, attributes: ViewConstants.labelAttributes)
        selectionLabel.textAlignment = .center
        pickerView.delegate = self
        pickerView.dataSource = self
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        errorLabel.numberOfLines = 0
        errorLabel.backgroundColor = Colors.backgroundHighlight
        errorLabel.alpha = Values.errorLabelBackgroundAlpha
        errorLabel.layer.masksToBounds = true
        errorLabel.layer.cornerRadius = Values.cornerRounding.value
        
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
        pickerLabel.textAlignment = .center
        
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
        view.addSubviews([titleLabel, selectionContainer, errorLabel, cancelButton, saveButton])
        [titleLabel, selectionContainer, selectionLabel, pickerView, errorLabel, cancelButton, saveButton].disableAutoresizingMask()
        
        selectionContainer.addSubviews([selectionLabel, pickerView])
    
        [titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ViewConstants.gridPadding),
         titleLabel.heightAnchor.constraint(equalToConstant: Values.labelHeight)].activate()
        
        [selectionContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         selectionContainer.bottomAnchor.constraint(equalTo: errorLabel.topAnchor)].activate()

        [selectionLabel.centerXAnchor.constraint(equalTo: selectionContainer.centerXAnchor),
         selectionLabel.topAnchor.constraint(equalTo: selectionContainer.topAnchor),
         selectionLabel.heightAnchor.constraint(equalToConstant: Values.labelHeight)].activate()
        
        [pickerView.centerXAnchor.constraint(equalTo: selectionContainer.centerXAnchor),
         pickerView.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor),
         pickerView.bottomAnchor.constraint(equalTo: selectionContainer.bottomAnchor)].activate()
        
        viewModel.viewData.quickDrawsSource.isEmpty ? layoutWithoutQuickDraws() : layoutWithQuickDraws()

        [errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         errorLabel.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: Values.errorLabelWidthMultiplier),
         errorLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -ViewConstants.gridPadding),
         errorLabel.heightAnchor.constraint(equalToConstant: Values.errorLabelHeight)].activate()
        
        [cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
        
        [saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
    }
    
    private func layoutWithQuickDraws() {
        view.addSubviews([quickDrawsLabel, quickDrawsStackView])
        [quickDrawsLabel, quickDrawsStackView].disableAutoresizingMask()
        
        quickDraws.forEach {
            quickDrawsStackView.addArrangedSubview($0)
        }
        
        [quickDrawsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         quickDrawsLabel.widthAnchor.constraint(equalToConstant: Values.quickDrawsWidth),
         quickDrawsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         quickDrawsLabel.heightAnchor.constraint(equalToConstant: Values.labelHeight)].activate()
        
        [quickDrawsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         quickDrawsStackView.widthAnchor.constraint(equalToConstant: Values.quickDrawsWidth),
         quickDrawsStackView.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor),
         quickDrawsStackView.bottomAnchor.constraint(equalTo: errorLabel.topAnchor, constant: -Values.quickDrawsBottomPadding)].activate()
        
        [selectionContainer.leadingAnchor.constraint(equalTo: quickDrawsStackView.trailingAnchor),
         selectionContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ViewConstants.gridPadding)].activate()
    }
    
    private func layoutWithoutQuickDraws() {
        [selectionContainer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         selectionContainer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -ViewConstants.gridPadding)].activate()
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
                vc.errorLabel.attributedText = .init(string: output.message, attributes: ViewConstants.labelAttributes)
            }).disposed(by: disposeBag)
        
        for (index, quickDraw) in quickDraws.enumerated() {
            quickDraw.rx.tap
                .map { VMInput.quickDrawTapped(.init(index: index)) }
                .bind(to: viewModel.input)
                .disposed(by: disposeBag)
        }
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.SelectModel.self)
            .append(weak: self)
            .subscribe(onNext: { vc, output in
                for (component, selection) in output.selections.enumerated() {
                    vc.pickerView.selectRow(selection, inComponent: component, animated: true)
                }
            }).disposed(by: disposeBag)
    }
}

extension InputPopoverViewController {
    private struct Values {
        static let cornerRounding: (value: CGFloat, corners: CACornerMask) = (20, [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        static let quickDrawsWidth: CGFloat = 160
        static let quickDrawsBottomPadding: CGFloat = 10
        static let quickDrawsSpacing: CGFloat = 5
        static let labelHeight: CGFloat = 40
        static let errorLabelHeight: CGFloat = 60
        static let errorLabelWidthMultiplier: CGFloat = 0.75
        static let errorLabelBackgroundAlpha: CGFloat = 0.8
        static let pickerItemPadding: CGFloat = 20
    }
    struct ViewData {
        let playerName: String
        let scoresSource: [[String]]
        let quickDrawsSource: [String]
    }
}

private extension UIButton {
    static func quickDraw(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setAttributedTitle(.init(string: title, attributes: ViewConstants.labelAttributes), for: .normal)
        button.backgroundColor = Colors.pointOfInterestBackground
        button.layer.borderColor = Colors.backgroundLine.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        return button
    }
}
