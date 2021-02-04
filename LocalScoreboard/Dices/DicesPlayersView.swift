//
//  DicesPlayersView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 04/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DicesPlayersView: UIView {
    private let players: [UIView]
    private let stackView = UIStackView(type: .horizontalBackground)
    
    init(viewData: ViewData) {
        players = viewData.players.map {
            let label = UILabel()
            label.attributedText = .init(string: $0, attributes: ViewConstants.labelAttributes)
            return label
        }
        
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func layoutSubviews() {
        let stackViewWidth = CGFloat(Int(bounds.width/ViewConstants.backgroundGridSize)) * ViewConstants.backgroundGridSize
        
        stackView.widthAnchor.constraint(equalToConstant: stackViewWidth).isActive = true
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         stackView.topAnchor.constraint(equalTo: topAnchor),
         stackView.heightAnchor.constraint(equalToConstant: Values.viewHeight),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
        
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
