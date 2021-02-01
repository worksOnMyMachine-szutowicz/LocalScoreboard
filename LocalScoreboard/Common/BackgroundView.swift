//
//  BackgroundView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 01/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class BackgroundView: UIView {
    init() {
        super.init(frame: .zero)
        
        backgroundColor = Colors.background
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        let verticalStackView = UIStackView(type: .verticalWithDefaultSpacing)
        verticalStackView.distribution = .equalCentering
        
        let horizontalStackView = UIStackView(type: .horizontalWithDefaultSpacing)
        horizontalStackView.distribution = .equalCentering
        
        addSubviewAndFill(verticalStackView)
        addSubviewAndFill(horizontalStackView)
        
        for _ in 0...Values.numberOfHorizontalLines{
            verticalStackView.addArrangedSubview(createLineView(orientation: .row))
        }
        for index in 0...Values.numberOfVerticalLines {
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
        static let numberOfHorizontalLines = Int(UIScreen.main.bounds.height/ViewConstants.backgroundGridSize)
        static let numberOfVerticalLines = Int(UIScreen.main.bounds.width/ViewConstants.backgroundGridSize)
        static let highlightedLineIndex = 4
    }
    
    private enum Orientation {
        case row
        case column
    }
}
