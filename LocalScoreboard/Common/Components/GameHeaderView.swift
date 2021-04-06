//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class GameHeaderView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()

    init(viewData: ViewData) {
        titleLabel.attributedText = .init(string: viewData.titleLabelText, attributes: Values.titleAttributes)
        titleLabel.textAlignment = .center
        descriptionLabel.attributedText = .init(string: viewData.descriptionLabelText, attributes: ViewConstants.labelAttributes)
        descriptionLabel.numberOfLines = 0

        super.init(frame: .zero)

        layout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func layout() {
        addSubviews([titleLabel, descriptionLabel])
        [titleLabel, descriptionLabel].disableAutoresizingMask()
        
        [titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
         titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
         titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: ViewConstants.gridPadding),
         titleLabel.heightAnchor.constraint(equalToConstant: Values.titleLabelHeight)].activate()
        
        [descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.sheetMarginPadding),
         descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConstants.padding),
         descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewConstants.gridPadding),
         descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
}

extension GameHeaderView {
    private struct Values {
        static let titleLabelHeight: CGFloat = 40
        static let titleAttributes: [NSAttributedString.Key : Any] = [.font: UIFont(name: "Chalkduster", size: 48) as Any]
    }
    
    struct ViewData {
        let titleLabelText: String
        let descriptionLabelText: String
    }
}
