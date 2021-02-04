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
    
    init(viewData: ViewData) {
        super.init(frame: .zero)
        
        title.attributedText = .init(string: viewData.title, attributes: ViewConstants.labelAttributes)
        title.textAlignment = .right
        content.backgroundColor = viewData.higlighted ? Colors.backgroundHighlight : nil
        content.alpha = Values.backgroundAlpha
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([title, content])
        [title, content].disableAutoresizingMask()
        
        [title.leadingAnchor.constraint(equalTo: leadingAnchor),
         title.widthAnchor.constraint(equalToConstant: ViewConstants.sheetMargin),
         title.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        [content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.sheetMargin),
         content.trailingAnchor.constraint(equalTo: trailingAnchor),
         content.topAnchor.constraint(equalTo: topAnchor),
         content.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
}

extension DicesBoardSectionView {
    private struct Values {
        static let backgroundAlpha: CGFloat = 0.8
    }
    struct ViewData {
        let title: String
        let higlighted: Bool
    }
}
