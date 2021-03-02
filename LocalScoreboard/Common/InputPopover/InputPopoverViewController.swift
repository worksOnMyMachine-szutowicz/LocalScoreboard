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
    private let quickDrawsLabel = UILabel()
    private let quickDraws: [UIButton]
    private let selectionLabel = UILabel()
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
        self.quickDraws = viewModel.viewData.quickDrawsSource.map { UIButton.quickDraw(title: $0) }
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
        view.backgroundColor = Colors.background
        view.layer.cornerRadius = Values.cornerRadius
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        titleLabel.attributedText = .init(string: String(format: "inputPopover.title".localized, viewModel.viewData.playerName), attributes: ViewConstants.highlightedLabelAttributes)
        titleLabel.textAlignment = .center
        quickDrawsLabel.attributedText = .init(string: "inputPopover.quickDraws".localized, attributes: ViewConstants.labelAttributes)
        quickDrawsLabel.textAlignment = .center
        selectionLabel.attributedText = .init(string: "inputPopover.selection".localized, attributes: ViewConstants.labelAttributes)
        selectionLabel.textAlignment = .center
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
        view.addSubviews([titleLabel, selectionLabel, pickerView, errorLabel, cancelButton, saveButton])
        [titleLabel, selectionLabel, pickerView, errorLabel, cancelButton, saveButton].disableAutoresizingMask()
    
        [titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.borderPadding),
         titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.borderPadding),
         titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Values.borderPadding),
         titleLabel.heightAnchor.constraint(equalToConstant: Values.labelHeight)].activate()

        [selectionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         selectionLabel.heightAnchor.constraint(equalToConstant: Values.labelHeight)].activate()
        
        [pickerView.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor),
         pickerView.bottomAnchor.constraint(equalTo: errorLabel.topAnchor)].activate()
        
        viewModel.viewData.quickDrawsSource.isEmpty ? layoutWithoutQuickDraws() : layoutWithQuickDraws()

        [errorLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.borderPadding),
         errorLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.borderPadding),
         errorLabel.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -Values.borderPadding),
         errorLabel.heightAnchor.constraint(equalToConstant: Values.errorLabelHeight)].activate()
        
        [cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
         cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
        
        [saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
         saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)].activate()
    }
    
    private func layoutWithQuickDraws() {
        let quickDrawsStackView = UIStackView(type: .verticalWithoutSpacing)
        view.addSubviews([quickDrawsLabel, quickDrawsStackView])
        [quickDrawsLabel, quickDrawsStackView].disableAutoresizingMask()
        
        quickDraws.forEach {
            quickDrawsStackView.addArrangedSubview($0)
        }
        
        [quickDrawsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.borderPadding),
         quickDrawsLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Values.quickDrawsWidthMulitplier),
         quickDrawsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
         quickDrawsLabel.heightAnchor.constraint(equalToConstant: Values.labelHeight)].activate()
        
        [selectionLabel.leadingAnchor.constraint(equalTo: quickDrawsLabel.trailingAnchor),
         selectionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.borderPadding)].activate()
        
        [quickDrawsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Values.borderPadding),
         quickDrawsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Values.quickDrawsWidthMulitplier),
         quickDrawsStackView.topAnchor.constraint(equalTo: selectionLabel.bottomAnchor),
         quickDrawsStackView.bottomAnchor.constraint(equalTo: errorLabel.topAnchor, constant: -Values.quickDrawsBottomPadding)].activate()
        
        [pickerView.leadingAnchor.constraint(equalTo: quickDrawsStackView.trailingAnchor),
         pickerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Values.borderPadding)].activate()
    }
    
    private func layoutWithoutQuickDraws() {
        selectionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
        static let cornerRadius: CGFloat = 20
        static let borderPadding: CGFloat = 20
        static let quickDrawsWidthMulitplier: CGFloat = 0.25
        static let quickDrawsBottomPadding: CGFloat = 10
        static let labelHeight: CGFloat = 40
        static let errorLabelHeight: CGFloat = 60
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
        button.layer.borderColor = Colors.backgroundLine.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        return button
    }
}
