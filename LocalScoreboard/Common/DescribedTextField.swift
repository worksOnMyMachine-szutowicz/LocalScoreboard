//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DescribedTextField: UIView {
    private let label = UILabel()
    private let textField = UITextField()

    init(labelText: String) {
        label.text = labelText
        textField.borderStyle = .roundedRect
        super.init(frame: .zero)

        layout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func layout() {
        addSubviews([label, textField])
        [label, textField].disableAutoresizingMask()

        heightAnchor.constraint(equalTo: textField.heightAnchor).isActive = true

        [label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.padding),
         label.widthAnchor.constraint(equalTo: widthAnchor, multiplier: Values.Label.widthMultiplier),
         label.centerYAnchor.constraint(equalTo: centerYAnchor)].activate()

        [textField.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: ViewConstants.padding),
        textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: ViewConstants.padding),
        textField.centerYAnchor.constraint(equalTo: centerYAnchor)].activate()
    }
}

extension DescribedTextField {
    struct Values {
        struct Label {
            static let widthMultiplier: CGFloat = 0.25
        }
    }
}