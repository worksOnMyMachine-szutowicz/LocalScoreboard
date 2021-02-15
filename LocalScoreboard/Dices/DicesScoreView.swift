//
//  DicesScoreView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 10/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DicesScoreView: UIView {
    private let scoreView = UIView()
    private let negativeScorePlaceholder = UIView()
    private let positiveScorePlaceholder = UIView()
    
    private var scoreHeight: NSLayoutConstraint?
    private var negativeScorePlaceholderHeight: NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        
        scoreView.backgroundColor = .green
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([scoreView, negativeScorePlaceholder, positiveScorePlaceholder])
        [scoreView, negativeScorePlaceholder, positiveScorePlaceholder].disableAutoresizingMask()
        
        negativeScorePlaceholderHeight = negativeScorePlaceholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Values.initialNegativePlaceholderHeightMultiplier)
        negativeScorePlaceholderHeight?.isActive = true
        [negativeScorePlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor),
         negativeScorePlaceholder.widthAnchor.constraint(equalTo: widthAnchor),
         negativeScorePlaceholder.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        scoreHeight = scoreView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Values.initialScoreHeightMultiplier)
        scoreHeight?.isActive = true
        [scoreView.centerXAnchor.constraint(equalTo: centerXAnchor),
         scoreView.widthAnchor.constraint(equalToConstant: Values.scoreWidth),
         scoreView.topAnchor.constraint(equalTo: negativeScorePlaceholder.bottomAnchor)].activate()
        
        [positiveScorePlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor),
         positiveScorePlaceholder.widthAnchor.constraint(equalTo: widthAnchor),
         positiveScorePlaceholder.topAnchor.constraint(equalTo: scoreView.bottomAnchor),
         positiveScorePlaceholder.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
    
    func changeScore(heightMultiplier: CGFloat?) {
        negativeScorePlaceholderHeight?.isActive = false
        scoreHeight?.isActive = false
        if let heightMultiplier = heightMultiplier {
            negativeScorePlaceholderHeight = negativeScorePlaceholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Values.initialNegativePlaceholderHeightMultiplier)
            scoreHeight = scoreView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier)
        } else {
            negativeScorePlaceholderHeight = negativeScorePlaceholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Values.halfOfSectionHeight)
            scoreHeight = scoreView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Values.halfOfSectionHeight)
        }
        negativeScorePlaceholderHeight?.isActive = true
        scoreHeight?.isActive = true
        
        
        UIView.animate(withDuration: ViewConstants.animationTime) { [weak self] () -> Void in
            self?.layoutIfNeeded()
        }
    }
}

extension DicesScoreView {
    private struct Values {
        static let scoreWidth: CGFloat = 40
        static let initialScoreHeightMultiplier: CGFloat = 0
        static let initialNegativePlaceholderHeightMultiplier: CGFloat = 1 / CGFloat(DicesBoardView.Values.numberOfSections)
        static let halfOfSectionHeight: CGFloat = 1 / 2 / CGFloat(DicesBoardView.Values.numberOfSections)
    }
}
