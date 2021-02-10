//
//  DicesPlayerView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 08/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class DicesPlayerView: UIView {
    let headerBottomAnchor: NSLayoutYAxisAnchor
    
    typealias VMInput = DicesPlayerViewModelInput
    typealias VMOutput = DicesPlayerViewModelOutput
    private let disposeBag = DisposeBag()
    private let viewModel: DicesPlayerViewModelInterface
    private let button: UIButton
    private let scoreContainer = UIView()
    private let scoreView = UIView()
    private let negativeScorePlaceholder = UIView()
    private let positiveScorePlaceholder = UIView()
    
    private var scoreHeight: NSLayoutConstraint?
    private var negativeScorePlaceholderHeight: NSLayoutConstraint?
    
    init(viewModel: DicesPlayerViewModelInterface) {
        self.viewModel = viewModel
        button =  UIButton.stickerButton(title: viewModel.viewData.name)
        headerBottomAnchor = button.bottomAnchor
        
        super.init(frame: .zero)
        
        scoreView.backgroundColor = .green
        
        layout()
        setupBindings()
    }
        
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([button, scoreContainer])
        scoreContainer.addSubviews([scoreView, negativeScorePlaceholder, positiveScorePlaceholder])
        [button, scoreContainer, scoreView, negativeScorePlaceholder, positiveScorePlaceholder].disableAutoresizingMask()
        
        [button.leadingAnchor.constraint(equalTo: leadingAnchor),
         button.widthAnchor.constraint(greaterThanOrEqualToConstant: Values.scoreWidth),
         button.trailingAnchor.constraint(equalTo: trailingAnchor),
         button.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        [scoreContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
         scoreContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
         scoreContainer.topAnchor.constraint(equalTo: button.bottomAnchor),
         scoreContainer.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
        
        negativeScorePlaceholderHeight = negativeScorePlaceholder.heightAnchor.constraint(equalTo: scoreContainer.heightAnchor, multiplier: Values.initialNegativePlaceholderHeightMultiplier)
        negativeScorePlaceholderHeight?.isActive = true
        [negativeScorePlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor),
         negativeScorePlaceholder.widthAnchor.constraint(equalTo: widthAnchor),
         negativeScorePlaceholder.topAnchor.constraint(equalTo: scoreContainer.topAnchor)].activate()
        
        scoreHeight = scoreView.heightAnchor.constraint(equalTo: scoreContainer.heightAnchor, multiplier: Values.initialScoreHeightMultiplier)
        scoreHeight?.isActive = true
        [scoreView.centerXAnchor.constraint(equalTo: centerXAnchor),
         scoreView.widthAnchor.constraint(equalToConstant: Values.scoreWidth),
         scoreView.topAnchor.constraint(equalTo: negativeScorePlaceholder.bottomAnchor)].activate()
        
        [positiveScorePlaceholder.centerXAnchor.constraint(equalTo: centerXAnchor),
         positiveScorePlaceholder.widthAnchor.constraint(equalTo: widthAnchor),
         positiveScorePlaceholder.topAnchor.constraint(equalTo: scoreView.bottomAnchor),
         positiveScorePlaceholder.bottomAnchor.constraint(equalTo: scoreContainer.bottomAnchor)].activate()
    }
    
    private func setupBindings() {
        button.rx.tap
            .map { _ in VMInput.addScoreTapped(.init(score: 40)) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable()
            .append(weak: self)
            .subscribe(onNext: { view, output in
                switch output {
                case .scoreChanged(let output):
                    view.changeScore(heightMultiplier: output.multiplier)
                }
            }).disposed(by: disposeBag)
    }
    
    private func changeScore(heightMultiplier: CGFloat?) {
        negativeScorePlaceholderHeight?.isActive = false
        scoreHeight?.isActive = false
        if let heightMultiplier = heightMultiplier {
            negativeScorePlaceholderHeight = negativeScorePlaceholder.heightAnchor.constraint(equalTo: scoreContainer.heightAnchor, multiplier: Values.initialNegativePlaceholderHeightMultiplier)
            scoreHeight = scoreView.heightAnchor.constraint(equalTo: scoreContainer.heightAnchor, multiplier: heightMultiplier)
        } else {
            negativeScorePlaceholderHeight = negativeScorePlaceholder.heightAnchor.constraint(equalTo: scoreContainer.heightAnchor, multiplier: Values.halfOfSectionHeight)
            scoreHeight = scoreView.heightAnchor.constraint(equalTo: scoreContainer.heightAnchor, multiplier: Values.halfOfSectionHeight)
        }
        negativeScorePlaceholderHeight?.isActive = true
        scoreHeight?.isActive = true
        
        
        UIView.animate(withDuration: ViewConstants.animationTime) { [weak self] () -> Void in
            self?.scoreContainer.layoutIfNeeded()
        }
    }
}

extension DicesPlayerView {
    private struct Values {
        static let scoreWidth: CGFloat = 40
        static let initialScoreHeightMultiplier: CGFloat = 0
        static let initialNegativePlaceholderHeightMultiplier: CGFloat = 1 / CGFloat(DicesBoardView.Values.numberOfSections)
        static let halfOfSectionHeight: CGFloat = 1 / 2 / CGFloat(DicesBoardView.Values.numberOfSections)
    }
    struct ViewData {
        let name: String
    }
}
