//
//  DicesBoardView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 03/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DicesBoardView: UIView {
    private let players: [DicesPlayerView]
    private let boardStackView = UIStackView(type: .verticalWithoutSpacing)
    private let playersStackView = UIStackView(type: .horizontalWithEqualSpacing)
    private let playersScrollView = UIScrollView()
    private let scrollViewClipper = UIView()
    
    private var boardHeightConstraint: NSLayoutConstraint?
    
    init(viewModel: DicesBoardViewModelInterface, viewFactory: DicesFactoryInterface, delegate: DicesPlayerViewDelegate) {
        players = viewModel.viewData.players.map {
            viewFactory.createPlayerView(viewModel: $0, delegate: delegate)
        }
        
        super.init(frame: .zero)
        
        playersScrollView.clipsToBounds = false
        scrollViewClipper.clipsToBounds = true
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func layoutSubviews() {
        boardHeightConstraint?.isActive = false
        
        let minimumBoardSize = CGFloat(Values.numberOfSections) * ViewConstants.backgroundGridSize
        let boardSize = CGFloat(Int(bounds.height/minimumBoardSize)) * minimumBoardSize
        boardHeightConstraint = boardStackView.heightAnchor.constraint(equalToConstant: boardSize)
        
        boardHeightConstraint?.isActive = true
    }
    
    private func layout() {
        addSubviews([boardStackView, scrollViewClipper])
        [boardStackView, scrollViewClipper, playersScrollView].disableAutoresizingMask()
        
        scrollViewClipper.addSubview(playersScrollView)
        playersScrollView.addSubviewAndFill(playersStackView)
        
        for index in 0..<Values.numberOfSections {
            let sectionTitle = String(index * 100)
            boardStackView.addArrangedSubview(DicesBoardSectionView(viewData: .init(title: sectionTitle, higlighted: Values.highlightedSections.contains(index), enlargedTitle: index == Values.enlargedTitleSection)))
        }
        players.forEach {
            playersStackView.addArrangedSubview($0)
        }
        
        [scrollViewClipper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.defaultSheetMargin),
         scrollViewClipper.trailingAnchor.constraint(equalTo: trailingAnchor),
         scrollViewClipper.topAnchor.constraint(equalTo: topAnchor),
         scrollViewClipper.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
        
        [playersScrollView.leadingAnchor.constraint(equalTo: scrollViewClipper.leadingAnchor),
         playersScrollView.trailingAnchor.constraint(equalTo: scrollViewClipper.trailingAnchor),
         playersScrollView.topAnchor.constraint(equalTo: scrollViewClipper.topAnchor),
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
        let players: [DicesPlayerViewModelInterface]
    }
}
