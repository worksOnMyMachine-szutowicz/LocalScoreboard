//
//  DicesBoardSectionView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 03/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DicesBoardSectionView: UIView {
    private let title = UILabel()
    private let content = UIView()
    private let bottomSeparator = UIView()
    private let contentSeparator = UIView()
    
    init(viewData: ViewData) {
        super.init(frame: .zero)
        
        title.attributedText = .init(string: viewData.title, attributes: viewData.enlargedTitle ? ViewConstants.highlightedLabelAttributes : ViewConstants.labelAttributes)
        title.textAlignment = .right
        content.backgroundColor = viewData.higlighted ? Colors.backgroundHighlight : nil
        content.alpha = Values.backgroundAlpha
        bottomSeparator.backgroundColor = .black
        contentSeparator.backgroundColor = .black
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([title, content, contentSeparator, bottomSeparator])
        [title, content, contentSeparator, bottomSeparator].disableAutoresizingMask()
        
        [title.leadingAnchor.constraint(equalTo: leadingAnchor),
         title.widthAnchor.constraint(equalToConstant: ViewConstants.sheetMargin),
         title.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
        
        [contentSeparator.leadingAnchor.constraint(equalTo: title.trailingAnchor),
         contentSeparator.widthAnchor.constraint(equalToConstant: Values.separatorSize),
         contentSeparator.topAnchor.constraint(equalTo: topAnchor),
         contentSeparator.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
        
        [content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.sheetMargin),
         content.trailingAnchor.constraint(equalTo: trailingAnchor),
         content.topAnchor.constraint(equalTo: topAnchor),
         content.bottomAnchor.constraint(equalTo: bottomSeparator.topAnchor)].activate()
        
        [bottomSeparator.leadingAnchor.constraint(equalTo: leadingAnchor),
         bottomSeparator.trailingAnchor.constraint(equalTo: trailingAnchor),
         bottomSeparator.bottomAnchor.constraint(equalTo: bottomAnchor),
         bottomSeparator.heightAnchor.constraint(equalToConstant: Values.separatorSize)].activate()
    }
}

extension DicesBoardSectionView {
    private struct Values {
        static let backgroundAlpha: CGFloat = 0.8
        static let separatorSize: CGFloat = 2
    }
    struct ViewData {
        let title: String
        let higlighted: Bool
        let enlargedTitle: Bool
    }
}
