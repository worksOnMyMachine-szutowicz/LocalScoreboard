//
//  DicesBoardView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 03/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DicesBoardView: UIView {
    private let boardStackView = UIStackView(type: .verticalWithoutSpacing)
    private let players: [DicesPlayerView]
    private let playersStackView = UIStackView(type: .horizontalWithEqualSpacing)
    
    init(viewData: ViewData, viewFactory: DicesFactoryInterface, delegate: DicesPlayerViewDelegate) {
        players = viewData.players.map {
            viewFactory.createPlayerView(playerName: $0, delegate: delegate)
        }
        
        super.init(frame: .zero)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func layoutSubviews() {
        let minimumBoardSize = CGFloat(Values.numberOfSections) * ViewConstants.backgroundGridSize
        let boardSize = CGFloat(Int(bounds.height/minimumBoardSize)) * minimumBoardSize
        boardStackView.heightAnchor.constraint(equalToConstant: boardSize).isActive = true
    }
    
    private func layout() {
        let playersScrollView = UIScrollView()
        addSubviews([boardStackView, playersScrollView])
        [boardStackView, playersScrollView].disableAutoresizingMask()
        
        playersScrollView.addSubviewAndFill(playersStackView)
        
        for index in 0..<Values.numberOfSections {
            let sectionTitle = String(index * 100)
            boardStackView.addArrangedSubview(DicesBoardSectionView(viewData: .init(title: sectionTitle, higlighted: Values.highlightedSections.contains(index), enlargedTitle: index == Values.enlargedTitleSection)))
        }
        players.forEach {
            playersStackView.addArrangedSubview($0)
        }
        
        [playersScrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.sheetMarginDoublePadding),
         playersScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
         playersScrollView.topAnchor.constraint(equalTo: topAnchor),
         playersScrollView.heightAnchor.constraint(equalTo: playersStackView.heightAnchor),
         playersScrollView.bottomAnchor.constraint(equalTo: boardStackView.bottomAnchor)].activate()
        
        [boardStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
         boardStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
         boardStackView.topAnchor.constraint(equalTo: players[0].headerBottomAnchor)].activate()
    }
}

extension DicesBoardView {
    struct Values {
        static let numberOfSections: Int = 11
        static let highlightedSections: [Int] = [4, 8]
        fileprivate static let enlargedTitleSection: Int = 10
    }
    struct ViewData {
        let players: [String]
    }
}
