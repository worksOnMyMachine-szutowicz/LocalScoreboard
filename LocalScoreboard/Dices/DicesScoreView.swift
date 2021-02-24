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
    private let scorePlaceholder = UIView()
    
    private var heightConstraints: [NSLayoutConstraint] = []
    
    init() {
        super.init(frame: .zero)
        
        scoreView.backgroundColor = .green
        scoreLabel.isHidden = true
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func changeScore(to score: Int) {
        setupHeightConstraints(for: score)
        setupScoreLabel(for: score)
        
        UIView.animate(withDuration: Values.animationTime.secondsValue) { [weak self] () -> Void in
            self?.layoutIfNeeded()
        }
    }
    
    private func layout() {
        addSubviews([scoreView, scoreLabel, scorePlaceholder])
        [scoreView, scoreLabel, scorePlaceholder].disableAutoresizingMask()
        
        [scorePlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor),
         scorePlaceholder.widthAnchor.constraint(equalTo: widthAnchor),
         scorePlaceholder.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        [scoreView.centerXAnchor.constraint(equalTo: centerXAnchor),
         scoreView.widthAnchor.constraint(equalToConstant: Values.scoreWidth),
         scoreView.topAnchor.constraint(equalTo: scorePlaceholder.bottomAnchor)].activate()
        
        scoreLabel.centerXAnchor.constraint(equalTo: scoreView.trailingAnchor).isActive = true

        setupHeightConstraints(for: 0)
    }
    
    private func setupHeightConstraints(for score: Int) {
        heightConstraints.deactivate()
        
        var scoreMultiplier: CGFloat
        var placeholderMultiplier: CGFloat
        if score < 0 {
            scoreMultiplier = min(CGFloat(abs(score)) * Values.scoreHeightMultiplier, Values.halfOfSectionHeight)
            placeholderMultiplier = Values.sectionHeight - scoreMultiplier
        } else {
            scoreMultiplier = CGFloat(score) * Values.scoreHeightMultiplier
            placeholderMultiplier = Values.sectionHeight
        }
        
        heightConstraints = [scorePlaceholder.heightAnchor.constraint(equalTo: heightAnchor, multiplier: placeholderMultiplier),
            scoreView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: scoreMultiplier)]
        heightConstraints.append(score < 0 ? scoreLabel.bottomAnchor.constraint(equalTo: scoreView.topAnchor) : scoreLabel.topAnchor.constraint(equalTo: scoreView.bottomAnchor))

        heightConstraints.activate()
    }
    
    private func setupScoreLabel(for score: Int) {
        scoreLabel.attributedText = .init(string: String(score), attributes: ViewConstants.labelAttributes)
        scoreLabel.isHidden = false
    }
}

extension DicesScoreView {
    struct Values {
        static var animationTime: (secondsValue: Double, milisecondsValue: Int) {
            (animationDuration, Int(animationDuration * 1000))
        }
        private static let animationDuration: Double = 0.03
        fileprivate static let scoreWidth: CGFloat = 40
        fileprivate static let sectionHeight: CGFloat = 1 / CGFloat(DicesBoardView.Values.numberOfSections)
        fileprivate static let halfOfSectionHeight: CGFloat = 1 / 2 / CGFloat(DicesBoardView.Values.numberOfSections)
        fileprivate static let scoreHeightMultiplier: CGFloat = 1 / 100 / CGFloat(DicesBoardView.Values.numberOfSections)
    }
}
