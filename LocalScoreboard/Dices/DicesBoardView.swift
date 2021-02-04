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
    
    private func layout() {
        addSubviewAndFill(stackView)
        
        for index in -1...10 {
            stackView.addArrangedSubview(DicesBoardSectionView(viewData: .init(title: String(index * 100), higlighted: index % 3 == 0)))
        }
    }
}
