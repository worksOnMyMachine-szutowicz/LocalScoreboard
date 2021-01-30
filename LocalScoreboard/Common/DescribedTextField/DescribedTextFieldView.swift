//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class DescribedTextFieldView: UIView {
    typealias VMOutput = DescribedTextFieldViewModelOutput
    private let disposeBag = DisposeBag()
    private let viewModel: DescribedTextFieldViewModelInterface
    private let label = UILabel()
    private let textField = UITextField()

    init(viewModel: DescribedTextFieldViewModelInterface) {
        self.viewModel = viewModel
        label.text = viewModel.viewData.labelText
        textField.borderStyle = .roundedRect
        
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
        textField.centerYAnchor.constraint(equalTo: centerYAnchor)].activate()
    }
    
    private func setupBindigs() {
        textField.rx.text.orEmpty
            .bind(to: viewModel.viewOutput)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.UpdateViewModel.self)
            .append(weak: self)
            .subscribe(onNext: { view, output in
                view.animateUpdate(labelText: output.labelText)
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
}

extension DescribedTextFieldView {
    struct Values {
        static let labelWidthMultiplier: CGFloat = 0.25
    }
}
