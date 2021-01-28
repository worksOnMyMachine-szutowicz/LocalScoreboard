//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class AddPlayersView: UIScrollView {
    private let headerContainer = UIView()
    private let headerTitle = UILabel()
    private let addButton = UIButton(type: .system)

    init() {
        headerContainer.backgroundColor = .systemGray4
        headerTitle.text = "newGame.addPlayer.title".localized
        addButton.setTitle("newGame.addPlayer.button".localized, for: .normal)
        addButton.titleLabel?.font = Values.headerTitleFont
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func layout() {
        headerContainer.addSubviews([headerTitle, addButton])

        let stackView = UIStackView(type: .verticalWithDefaultSpacing)

        addSubviews([headerContainer, stackView])
        [headerContainer, headerTitle, addButton, stackView].disableAutoresizingMask()

        [headerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
        headerContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        headerContainer.topAnchor.constraint(equalTo: topAnchor),
        headerContainer.heightAnchor.constraint(equalTo: addButton.heightAnchor)].activate()

        [headerTitle.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: ViewConstants.padding),
         headerTitle.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)].activate()

        [addButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -ViewConstants.padding),
        addButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)].activate()

        [stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.padding),
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -2 * ViewConstants.padding),
        stackView.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: ViewConstants.padding),
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ViewConstants.padding),
        stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -3 * ViewConstants.padding)].activate()

        stackView.addArrangedSubview(DescribedTextField(labelText: "gracz1"))
        stackView.addArrangedSubview(DescribedTextField(labelText: "gracz2"))
    }
}

extension AddPlayersView {
    struct Values {
        static let headerTitleFont: UIFont = .systemFont(ofSize: 25)
    }
}