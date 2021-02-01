//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class GameHeaderView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    init(viewData: ViewData) {
        titleLabel.text = viewData.titleLabelText
        titleLabel.font = Values.titleFont
        titleLabel.textAlignment = .center
        descriptionLabel.text = viewData.descriptionLabelText
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
        addSubviewAndFillToSafeArea(stackView, insets: Values.stackViewInsets)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
    }
}

extension GameHeaderView {
    private struct Values {
        static let titleFont: UIFont = .boldSystemFont(ofSize: 50)
        static let description: UIFont = .systemFont(ofSize: 15)
        static let stackViewInsets: UIEdgeInsets = .init(top: 40, left: ViewConstants.padding, bottom: ViewConstants.padding, right: ViewConstants.padding)
    }
    
    struct ViewData {
        let titleLabelText: String
        let descriptionLabelText: String
    }
}
