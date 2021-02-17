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
    private let scoreLabel = UILabel()
    private let negativeScorePlaceholder = UIView()
    private let positiveScorePlaceholder = UIView()
    
    private var scoreHeight: NSLayoutConstraint?
    private var negativeScorePlaceholderHeight: NSLayoutConstraint?
    private var scoreLabelVerticalPosition: NSLayoutConstraint?
    
    init() {
        super.init(frame: .zero)
        
        scoreView.backgroundColor = .green
        scoreLabel.isHidden = true
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([scoreView, scoreLabel, negativeScorePlaceholder, positiveScorePlaceholder])
        [scoreView, scoreLabel, negativeScorePlaceholder, positiveScorePlaceholder].disableAutoresizingMask()
        
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
        
        scoreLabelVerticalPosition = scoreLabel.topAnchor.constraint(equalTo: scoreView.bottomAnchor)
        scoreLabelVerticalPosition?.isActive = true
        scoreLabel.centerXAnchor.constraint(equalTo: scoreView.rightAnchor).isActive = true
        
        [positiveScorePlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor),
         positiveScorePlaceholder.widthAnchor.constraint(equalTo: widthAnchor),
         positiveScorePlaceholder.topAnchor.constraint(equalTo: scoreView.bottomAnchor),
         positiveScorePlaceholder.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
    
    func changeScore(to score: Int) {
        toggleChangeableConstraints()
        setupScoreLabel(for: score)
        
        if let heightMultiplier = calculateHeightMultiplier(score: score) {
            negativeScorePlaceholderHeight = negativeScorePlaceholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Values.initialNegativePlaceholderHeightMultiplier)
            scoreHeight = scoreView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: heightMultiplier)
            scoreLabelVerticalPosition = scoreLabel.topAnchor.constraint(equalTo: scoreView.bottomAnchor)
        } else {
            negativeScorePlaceholderHeight = negativeScorePlaceholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Values.halfOfSectionHeight)
            scoreHeight = scoreView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: Values.halfOfSectionHeight)
            scoreLabelVerticalPosition = scoreLabel.bottomAnchor.constraint(equalTo: scoreView.topAnchor)
        }
        
        toggleChangeableConstraints()
        
        UIView.animate(withDuration: ViewConstants.animationTime) { [weak self] () -> Void in
            self?.layoutIfNeeded()
        }
    }
    
    private func calculateHeightMultiplier(score: Int) -> CGFloat? {
        if score < 0 {
            return nil
        }
        let multiplier = CGFloat(score) / 100 / CGFloat(DicesBoardView.Values.numberOfSections)
        return multiplier
    }
    
    private func toggleChangeableConstraints() {
        negativeScorePlaceholderHeight?.isActive.toggle()
        scoreHeight?.isActive.toggle()
        scoreLabelVerticalPosition?.isActive.toggle()
    }
    
    private func setupScoreLabel(for score: Int) {
        if score != 0 {
            scoreLabel.attributedText = .init(string: String(score), attributes: ViewConstants.labelAttributes)
            scoreLabel.isHidden = false
        } else {
            scoreLabel.isHidden = true
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
