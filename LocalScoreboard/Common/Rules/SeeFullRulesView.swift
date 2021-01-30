//
//  SeeRulesView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 30/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

protocol SeeFullRulesViewDelegate: class {
    func pushRulesView(gameData: GameData)
}

class SeeFullRulesView: UIView {
    private let disposeBag = DisposeBag()
    private weak var delegate: SeeFullRulesViewDelegate?
    private let gameData: GameData
    private let titleLabel = UILabel()
    private let chevronLabel = UILabel()
    private let gestureRecognizer = UITapGestureRecognizer()
    
    init(delegate: SeeFullRulesViewDelegate?, gameData: GameData) {
        self.delegate = delegate
        self.gameData = gameData
        
        super.init(frame: .zero)
        
        backgroundColor = .systemGray
        addGestureRecognizer(gestureRecognizer)
        titleLabel.text = "newGame.seeRules.title".localized
        chevronLabel.text = "newGame.seeRules.chevron".localized
        
        layout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([titleLabel, chevronLabel])
        [titleLabel, chevronLabel].disableAutoresizingMask()
        
        heightAnchor.constraint(equalTo: titleLabel.heightAnchor, constant: Values.viewHeight).isActive = true
        
        [titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: ViewConstants.padding),
         titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)].activate()
        
        [chevronLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConstants.padding),
         chevronLabel.centerYAnchor.constraint(equalTo: centerYAnchor)].activate()
    }
    
    private func setupBindings() {
        gestureRecognizer.rx.event
            .filter { $0.state == .ended }
            .append(weak: self)
            .subscribe(onNext: { view, _ in
                view.delegate?.pushRulesView(gameData: view.gameData)
            }).disposed(by: disposeBag)
    }
}

extension SeeFullRulesView {
    private struct Values {
        static let viewHeight: CGFloat = 20
    }
}
