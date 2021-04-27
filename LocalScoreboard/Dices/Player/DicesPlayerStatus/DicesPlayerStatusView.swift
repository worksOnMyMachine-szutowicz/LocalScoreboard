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
    
    private let stackView = UIStackView()
    private var statuses: [(status: Statuses, view: UIView)] = []
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = Colors.background
        layer.cornerRadius = Values.cornerRadius
        stackView.spacing = ViewConstants.padding
        stackView.distribution = .fillEqually
        
        layout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviewAndFill(stackView, insets: .init(top: 0, left: ViewConstants.padding, bottom: 0, right: ViewConstants.padding))
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.AddStatusModel.self)
            .append(weak: self)
            .subscribe(onNext: { view, input in
                view.addStatus(model: input)
            }).disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.RemoveStatusModel.self)
            .append(weak: self)
            .subscribe(onNext: { view, input in
                view.removeStatus(model: input)
            }).disposed(by: disposeBag)
    }
    
    private func addStatus(model: Input.AddStatusModel) {
        let animationView = AnimationView(name: model.status.animation.rawValue)
        animationView.loopMode = .loop
        animationView.isHidden = true
        
        statuses.append((status: model.status, view: animationView))
        stackView.addArrangedSubview(animationView)
        UIView.animate(withDuration: ViewConstants.animationTime) { () -> Void in
            animationView.isHidden = false
        }
        animationView.play()
        
        if let duration = model.duration {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.removeStatus(model: .init(status: model.status))
            }
        }
    }
    
    private func removeStatus(model: Input.RemoveStatusModel) {
        guard let activeStatusIndex = statuses.firstIndex(where: { $0.status == model.status }) else { return }
        let activeStatus = statuses[activeStatusIndex]
        statuses.remove(at: activeStatusIndex)
        
        UIView.animate(withDuration: ViewConstants.animationTime, animations: { () -> Void in
            activeStatus.view.isHidden = true
        }, completion: { _ in
            activeStatus.view.removeFromSuperview()
        })
    }
}

extension DicesPlayerStatusView {
    private struct Values {
        static let cornerRadius: CGFloat = 20
    }
    enum Statuses {
        case protected
        case surpassed
        case onPassage
        
        fileprivate var animation: Animations {
            switch self {
            case .protected:
                return .shield
            case .surpassed:
                return .hit
            case .onPassage:
                return .errorCone
            }
        }
    }
}
