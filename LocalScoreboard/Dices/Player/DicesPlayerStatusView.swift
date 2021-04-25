//
//  DicesPlayerStatusView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 25/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import Lottie
import RxSwift
import RxCocoa

class DicesPlayerStatusView: UIView, DicesPlayerStatusViewInterface {
    typealias Input = DicesPlayerStatusViewInput
    private let disposeBag = DisposeBag()
    let input = PublishRelay<Input>()
    
    private let stackView = UIStackView(type: .horizontalWithEqualSpacing)
    
    init() {
        super.init(frame: .zero)
        
        stackView.spacing = ViewConstants.padding
        
        layout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviewAndFill(stackView, insets: .init(top: 0, left: ViewConstants.padding, bottom: 0, right: ViewConstants.padding))
        
        heightAnchor.constraint(equalToConstant: Values.height).isActive = true
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.AddStatusModel.self)
            .append(weak: self)
            .subscribe(onNext: { view, input in
                view.addStatus(model: input)
            }).disposed(by: disposeBag)
    }
    
    private func addStatus(model: Input.AddStatusModel) {
        let animationView = AnimationView(name: model.status.animation.rawValue)
        animationView.loopMode = .loop
        animationView.isHidden = true
        
        stackView.addArrangedSubview(animationView)
        UIView.animate(withDuration: ViewConstants.animationTime) { [weak self] () -> Void in
            self?.layoutIfNeeded()
            animationView.isHidden = false
        }
        animationView.play()
        
        if let duration = model.duration {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.removeStatus(view: animationView)
            }
        }
    }
    
    private func removeStatus(view: AnimationView) {
        UIView.animate(withDuration: ViewConstants.animationTime, animations: { () -> Void in
            view.isHidden = true
        }, completion: { _ in
            view.removeFromSuperview()
        })
    }
}

extension DicesPlayerStatusView {
    private struct Values {
        static let height: CGFloat = 40
    }
    enum Statuses {
        case surpassed
        
        var animation: Animations {
            switch self {
            case .surpassed:
                return .hit
            }
        }
    }
}
