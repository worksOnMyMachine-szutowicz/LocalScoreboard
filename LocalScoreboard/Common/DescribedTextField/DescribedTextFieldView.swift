//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class DescribedTextFieldView: UIView {
    typealias VMInput = DescribedTextFieldViewModelInput
    typealias VMOutput = DescribedTextFieldViewModelOutput
    private let disposeBag = DisposeBag()
    private let viewModel: DescribedTextFieldViewModelInterface
    private let label = UILabel()
    private let textField = UITextField()

    init(viewModel: DescribedTextFieldViewModelInterface) {
        self.viewModel = viewModel
        label.attributedText = .init(string: viewModel.viewData.labelText, attributes: ViewConstants.labelAttributes)
        textField.layer.borderWidth = Values.textFieldDefaultBorderWidth
        textField.layer.borderColor = Colors.backgroundLine.cgColor
        textField.layer.cornerRadius = Values.textFieldCornerRadius
        textField.backgroundColor = Colors.background
        textField.setHorizontalPadding()
        
        super.init(frame: .zero)

        layout()
        setupBindigs()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func layout() {
        addSubviews([label, textField])
        [label, textField].disableAutoresizingMask()

        heightAnchor.constraint(equalTo: textField.heightAnchor).isActive = true

        [label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.padding),
         label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Values.labelWidthMultiplier),
         label.centerYAnchor.constraint(equalTo: centerYAnchor)].activate()

        [textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: ViewConstants.padding),
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ViewConstants.padding),
        textField.heightAnchor.constraint(equalToConstant: Values.textFieldHeight)].activate()
    }
    
    private func setupBindigs() {
        textField.rx.text.orEmpty
            .map { VMInput.userInput(.init(input: $0)) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.UpdateViewModel.self)
            .append(weak: self)
            .subscribe(onNext: { view, output in
                view.animateUpdate(labelText: output.labelText)
            }).disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.ValidationResultModel.self)
            .append(weak: self)
            .subscribe(onNext: { view, validationResult in
                view.indicateValidationResult(validationResult.result)
            }).disposed(by: disposeBag)
    }
    
    private func animateUpdate(labelText: String) {
        UIView.animate(withDuration: ViewConstants.animationTime, animations: { [weak self] () -> Void in
            self?.label.alpha = 0
        })
        label.text = labelText
        UIView.animate(withDuration: ViewConstants.animationTime, animations: { [weak self] () -> Void in
            self?.label.alpha = 1
        })
    }
    
    private func indicateValidationResult(_ result: Bool) {
        textField.layer.borderColor = result ? Colors.backgroundLine.cgColor : Colors.backgroundHighlight.cgColor
        textField.layer.borderWidth = result ? Values.textFieldDefaultBorderWidth : Values.textFieldHighlightedBorderWidth
    }
}

extension DescribedTextFieldView {
    private struct Values {
        static let labelWidthMultiplier: CGFloat = 0.25
        static let textFieldHeight: CGFloat = 2 * ViewConstants.backgroundGridSize
        static let textFieldDefaultBorderWidth: CGFloat = 2
        static let textFieldHighlightedBorderWidth: CGFloat = 3
        static let textFieldCornerRadius: CGFloat = 5
    }
    
    struct ViewData {
        let labelText: String
    }
}
