//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class GameHeaderView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    init(title: String, description: String) {
        titleLabel.text = title
        titleLabel.font = Values.titleFont
        titleLabel.textAlignment = .center
        descriptionLabel.text = description
        descriptionLabel.font = Values.description
        descriptionLabel.numberOfLines = 0

        super.init(frame: .zero)

        layout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func layout() {
        let stackView = UIStackView(type: .verticalWithDefaultSpacing)
        addSubviewAndFill(stackView, insets: Values.stackViewInsets)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
}

extension GameHeaderView {
    struct Values {
        static let titleFont: UIFont = .boldSystemFont(ofSize: 40)
        static let description: UIFont = .systemFont(ofSize: 15)
        static let stackViewInsets: UIEdgeInsets = .init(top: 50, left: ViewConstants.padding, bottom: ViewConstants.padding, right: ViewConstants.padding)
    }
}