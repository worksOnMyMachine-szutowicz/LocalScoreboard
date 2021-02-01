//
//  BackgroundView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 01/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    init(for view: UIView) {
        super.init(frame: .zero)
        
        backgroundColor = Colors.background
        
        layout(bounds: view.bounds)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout(bounds: CGRect) {
        let verticalStackView = UIStackView(type: .verticalBackground)
        let horizontalStackView = UIStackView(type: .horizontalBackground)
        
        addSubviewAndFill(verticalStackView)
        addSubviewAndFill(horizontalStackView)
        
        let numberOfHorizontalLines = Int(bounds.height/ViewConstants.backgroundGridSize)
        let numberOfVerticalLines = Int(bounds.width/ViewConstants.backgroundGridSize)
        
        for _ in 0...numberOfHorizontalLines {
            verticalStackView.addArrangedSubview(createLineView(orientation: .row))
        }
        for index in 0...numberOfVerticalLines {
            horizontalStackView.addArrangedSubview(createLineView(orientation: .column, highlighted: index == Values.highlightedLineIndex))
        }
    }
    
    private func createLineView(orientation: Orientation, highlighted: Bool = false) -> UIView {
        let line = UIView()
        line.backgroundColor = highlighted ? Colors.backgroundHighlight : Colors.backgroundLine
            
        if orientation == .row {
            line.heightAnchor.constraint(equalToConstant: Values.lineSize).isActive = true
        } else {
            line.widthAnchor.constraint(equalToConstant: Values.lineSize).isActive = true
        }
        return line
    }
}

extension BackgroundView {
    private struct Values {
        static let lineSize: CGFloat = 1
        static let highlightedLineIndex: Int = Int(ViewConstants.sheetMargin / ViewConstants.backgroundGridSize)
    }
    
    private enum Orientation {
        case row
        case column
    }
}
