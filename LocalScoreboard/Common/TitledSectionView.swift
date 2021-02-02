//
//  TitledSectionView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 30/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class TitledSectionView: UIView {
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let contentLabel = UILabel()
    
    init(viewData: ViewData) {
        super.init(frame: .zero)
        
        headerView.backgroundColor = Colors.backgroundHighlight
        titleLabel.attributedText = .init(string: viewData.titleLabelText, attributes: ViewConstants.highlightedLabelAttributes)
        contentLabel.attributedText = .init(string: viewData.contentLabelText, attributes: ViewConstants.labelAttributes)
        contentLabel.numberOfLines = 0
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        headerView.addSubview(titleLabel)
        addSubviews([headerView, contentLabel])
        [headerView, titleLabel, contentLabel].disableAutoresizingMask()
        
        [headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
         headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
         headerView.topAnchor.constraint(equalTo: topAnchor),
         headerView.heightAnchor.constraint(equalToConstant: Values.headerViewHeight)].activate()
        
        [titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: ViewConstants.padding),
         titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)].activate()
        
        [contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.sheetMarginPadding),
         contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConstants.padding),
         contentLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: ViewConstants.verticalPadding),
         contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
}

extension TitledSectionView {
    private struct Values {
        static let headerViewHeight: CGFloat = 2 * ViewConstants.backgroundGridSize
    }
    struct ViewData {
        let titleLabelText: String
        let contentLabelText: String
    }
}
