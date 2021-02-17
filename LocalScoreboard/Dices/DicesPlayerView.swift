//
//  DicesPlayerView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 08/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

protocol DicesPlayerViewDelegate: class {
    func showAddScoreView(for player: String) -> Observable<Int>
}

class DicesPlayerView: UIView {
    let headerBottomAnchor: NSLayoutYAxisAnchor
    
    typealias VMInput = DicesPlayerViewModelInput
    typealias VMOutput = DicesPlayerViewModelOutput
    private let disposeBag = DisposeBag()
    private let viewModel: DicesPlayerViewModelInterface
    private weak var delegate: DicesPlayerViewDelegate?
    private let button: UIButton
    private let scoreView = DicesScoreView()

    init(viewModel: DicesPlayerViewModelInterface, delegate: DicesPlayerViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        button =  UIButton.stickerButton(title: viewModel.viewData.name)
        headerBottomAnchor = button.bottomAnchor
        
        super.init(frame: .zero)
        
        layout()
        setupBindings()
    }
        
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([button, scoreView])
        [button, scoreView].disableAutoresizingMask()
        
        [button.leadingAnchor.constraint(equalTo: leadingAnchor),
         button.widthAnchor.constraint(greaterThanOrEqualToConstant: Values.minimumWidth),
         button.trailingAnchor.constraint(equalTo: trailingAnchor),
         button.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        [scoreView.leadingAnchor.constraint(equalTo: leadingAnchor),
         scoreView.trailingAnchor.constraint(equalTo: trailingAnchor),
         scoreView.topAnchor.constraint(equalTo: button.bottomAnchor),
         scoreView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
    
    private func setupBindings() {
        button.rx.tap
            .append(weak: self)
            .flatMapLatest { view, _ -> Observable<Int> in
                guard let delegate = view.delegate else { return .empty() }
                return delegate.showAddScoreView(for: view.viewModel.viewData.name)
            }
            .map { VMInput.addScore(.init(score: $0)) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable()
            .append(weak: self)
            .subscribe(onNext: { view, output in
                switch output {
                case .scoreChanged(let output):
                    view.scoreView.changeScore(heightMultiplier: output.multiplier)
                }
            }).disposed(by: disposeBag)
    }
}

extension DicesPlayerView {
    private struct Values {
        static let minimumWidth: CGFloat = 40
    }
    
    struct ViewData {
        let name: String
    }
}