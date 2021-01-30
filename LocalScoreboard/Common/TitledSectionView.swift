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
        
        headerView.backgroundColor = .systemGray4
        titleLabel.text = viewData.titleLabelText
        contentLabel.text = viewData.contnetLabelText
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
         headerView.heightAnchor.constraint(equalTo: titleLabel.heightAnchor, constant: Values.headerViewHeight)].activate()
        
        [titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: ViewConstants.padding),
         titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)].activate()
        
        [contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.padding),
         contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConstants.padding),
         contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: ViewConstants.padding),
         contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: ViewConstants.padding)].activate()
    }
}

extension TitledSectionView {
    private struct Values {
        static let headerViewHeight: CGFloat = 20
    }
    struct ViewData {
        let titleLabelText: String
        let contnetLabelText: String
    }
}
