//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class AddPlayersView: UIScrollView {
    private let addButton = UIButton(type: .system)

    init() {
        addButton.setTitle("newGame.addPlayer.button".localized, for: .normal)
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func layout() {
        let stackView = UIStackView(type: .verticalWithDefaultSpacing)

        addSubviews([addButton, stackView])
        [addButton, stackView].disableAutoresizingMask()

        [addButton.leadingAnchor.constraint(equalTo: leadingAnchor),
        addButton.topAnchor.constraint(equalTo: topAnchor)].activate()

        [stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
        stackView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: Values.stackViewTopPadding),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        stackView.widthAnchor.constraint(equalTo: widthAnchor)].activate()

        stackView.addArrangedSubview(DescribedTextField(labelText: "gracz1"))
        stackView.addArrangedSubview(DescribedTextField(labelText: "gracz2"))
    }
}

extension AddPlayersView {
    struct Values {
        static let stackViewTopPadding: CGFloat = 10
    }
}