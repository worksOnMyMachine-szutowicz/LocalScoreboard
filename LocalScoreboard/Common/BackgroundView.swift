//
//  BackgroundView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 01/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    private let verticalStackView = UIStackView(type: .verticalBackground)
    private let horizontalStackView = UIStackView(type: .horizontalBackground)
    
    init(for view: UIView, withMargin margin: CGFloat) {
        super.init(frame: .zero)
        
        backgroundColor = Colors.background
        clipsToBounds = true
        
        layout(bounds: view.bounds, margin: margin)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout(bounds: CGRect, margin: CGFloat) {
        let highlightedLineIndex = Int(margin / ViewConstants.backgroundGridSize)
        
        let bottomUncoveredSpace = CGFloat(Int(bounds.height) % Int(ViewConstants.backgroundGridSize)) - ViewConstants.backgroundLineSize
        let rightUncoveredSpace = CGFloat(Int(bounds.width) % Int(ViewConstants.backgroundGridSize)) - ViewConstants.backgroundLineSize
        
        addSubviewAndFill(verticalStackView, insets: .init(top: 0, left: 0, bottom: bottomUncoveredSpace, right: 0))
        addSubviewAndFill(horizontalStackView, insets: .init(top: 0, left: 0, bottom: 0, right: rightUncoveredSpace))
        
        let numberOfHorizontalLines = Int(bounds.height/ViewConstants.backgroundGridSize)
        let numberOfVerticalLines = Int(bounds.width/ViewConstants.backgroundGridSize)
        
        for _ in 0...numberOfHorizontalLines {
            verticalStackView.addArrangedSubview(createLineView(orientation: .row))
        }
        for index in 0...numberOfVerticalLines {
            horizontalStackView.addArrangedSubview(createLineView(orientation: .column, highlighted: index == highlightedLineIndex))
        }
    }
    
    private func createLineView(orientation: Orientation, highlighted: Bool = false) -> UIView {
        let line = UIView()
        line.backgroundColor = highlighted ? Colors.backgroundHighlight : Colors.backgroundLine
            
        if orientation == .row {
            line.heightAnchor.constraint(equalToConstant: ViewConstants.backgroundLineSize).isActive = true
        } else {
            line.widthAnchor.constraint(equalToConstant: ViewConstants.backgroundLineSize).isActive = true
        }
        return line
    }
}

extension BackgroundView {
    private enum Orientation {
        case row
        case column
    }
}
