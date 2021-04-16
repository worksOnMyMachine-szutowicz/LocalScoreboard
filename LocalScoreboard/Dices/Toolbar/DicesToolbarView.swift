//
//  DicesToolbarView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 06/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class DicesToolbarView: UIView {
    typealias VMInput = DicesToolbarViewModelInput
    typealias VMOutput = DicesToolbarViewModelOutput
    private let disposeBag = DisposeBag()
    private let viewModel: DicesToolbarViewModelInterface
    
    private let stackView = UIStackView(type: .horizontalBackground)
    
    private lazy var stackViewHiddenConstraints = [stackView.leadingAnchor.constraint(equalTo: trailingAnchor)]
    private lazy var stackViewVisibleContraints = [stackView.leadingAnchor.constraint(equalTo: leadingAnchor)]
    
    init(viewModel: DicesToolbarViewModelInterface) {
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        layout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [stackView.topAnchor.constraint(equalTo: topAnchor),
         stackView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
        stackViewVisibleContraints.activate()
    }
    
    private func setupBindings() {
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.RefreshModel.self)
            .append(weak: self)
            .subscribe(onNext: { view, output in
                view.refresh(with: output.buttons)
            }).disposed(by: disposeBag)
    }
    
    private func refresh(with buttons: [DicesToolbarViewModel.ButtonViewData]) {
        stackViewVisibleContraints.deactivate()
        stackViewHiddenConstraints.activate()
        stackView.subviews.forEach {
            $0.removeFromSuperview()
        }
        UIView.animate(withDuration: ViewConstants.animationTime, animations: { [weak self] () -> Void in
            self?.layoutIfNeeded()
        })
                
        buttons.forEach { buttonModel in
            let button = UIButton.stickerButton(title: buttonModel.title)
            button.rx.tap
                .map {
                    switch buttonModel.type {
                    case .add:
                        return VMInput.addTapped(.init())
                    case .punishment:
                        return VMInput.punishmentTapped(.init())
                    case .next:
                        return VMInput.nextTapped(.init())
                    }
                }.bind(to: viewModel.input)
                .disposed(by: disposeBag)
            
            stackView.addArrangedSubview(button)
        }
        
        stackViewHiddenConstraints.deactivate()
        stackViewVisibleContraints.activate()
        UIView.animate(withDuration: ViewConstants.animationTime, animations: { [weak self] () -> Void in
            self?.layoutIfNeeded()
        })
    }
}
