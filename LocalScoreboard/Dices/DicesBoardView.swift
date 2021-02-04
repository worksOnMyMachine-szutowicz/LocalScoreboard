//
//  DicesBoardView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 03/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DicesBoardView: UIView {
    private let stackView = UIStackView(type: .verticalWithoutSpacing)
    
    init() {
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func layoutSubviews() {
        let minimumBoardSize = CGFloat(Values.numberOfSections) * ViewConstants.backgroundGridSize
        let boardSize = CGFloat(Int(bounds.height/minimumBoardSize)) * minimumBoardSize
        stackView.heightAnchor.constraint(equalToConstant: boardSize).isActive = true
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
         stackView.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        for index in 0..<Values.numberOfSections {
            let sectionTitle = String(index * 100)
            stackView.addArrangedSubview(DicesBoardSectionView(viewData: .init(title: sectionTitle, higlighted: Values.highlightedSections.contains(index), enlargedTitle: index == Values.enlargedTitleSection)))
        }
        
    }
}

extension DicesBoardView {
    private struct Values {
        static let numberOfSections: Int = 11
        static let highlightedSections: [Int] = [4, 8]
        static let enlargedTitleSection: Int = 10
    }
}
