//
//  DicesPlayersView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 04/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DicesPlayersView: UIScrollView {
    private let players: [UIView]
    private let stackView = UIStackView(type: .horizontalWithEqualSpacing)
    
    init(viewData: ViewData) {
        players = viewData.players.map {
            let label = UILabel()
            label.attributedText = .init(string: $0, attributes: ViewConstants.highlightedLabelAttributes)
            return label
        }
        
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviewAndFill(stackView)
        
        heightAnchor.constraint(equalToConstant: Values.viewHeight).isActive = true
        
        players.forEach {
            stackView.addArrangedSubview($0)
        }
    }
}

extension DicesPlayersView {
    private struct Values {
        static let viewHeight: CGFloat = 40
    }
    struct ViewData {
        let players: [String]
    }
}
