//
//  AnimatedButtonView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 06/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

class AnimatedButtonView: UIView, AnimatedButtonInterface {
    typealias Input = AnimatedButtonInput
    typealias Output = AnimatedButtonOutput
    private let disposeBag = DisposeBag()
    private let outputRelay = PublishRelay<Output>()
    let input = PublishRelay<Input>()
    var output: Driver<Output> {
        outputRelay.asDriver(onErrorRecover: { _ in .empty() })
    }
    
    private let button = UIButton(type: .system)
    private let animation: AnimationView
    private let background = UIView()
    
    private var viewWidth: CGFloat {
        let buttonWidth = Int(button.titleLabel?.textWidth ?? 0) + Int(ViewConstants.backgroundGridSize)
        return CGFloat(buttonWidth + (Int(ViewConstants.backgroundGridSize) - (Int(buttonWidth) % Int(ViewConstants.backgroundGridSize))))
    }
    
    init(text: NSAttributedString, animation: Animations, backgroundColor: UIColor) {
        self.animation = AnimationView(name: animation.rawValue)
        
        super.init(frame: .zero)
        
        button.setAttributedTitle(text, for: .normal)
        button.backgroundColor = .clear
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: ViewConstants.padding, bottom: 0, right: ViewConstants.padding)
        self.animation.loopMode = .loop
        background.backgroundColor = backgroundColor
        background.layer.cornerRadius = Values.cornerRadius
        
        layout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviewAndFill(background)
        addSubviewAndFill(animation)
        addSubviewAndFill(button)
        
        [heightAnchor.constraint(equalToConstant: Values.height),
         widthAnchor.constraint(equalToConstant: viewWidth)].activate()
    }
    
    private func setupBindings() {
        input.asObservable()
            .append(weak: self)
            .subscribe(onNext: { view, input in
                switch input {
                case .animate:
                    view.animation.play()
                case .stopAnimating:
                    view.animation.stop()
                }
            }).disposed(by: disposeBag)
        
        button.rx.tap
            .map { Output.tapped(.init()) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}

extension AnimatedButtonView {
    private struct Values {
        static let height: CGFloat = 40
        static let cornerRadius: CGFloat = 20
    }
}
