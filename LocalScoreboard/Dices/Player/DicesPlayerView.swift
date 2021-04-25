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
    func showAddScoreView(for viewModel: InputPopoverViewModelInterface) -> Observable<Int?>
}

class DicesPlayerView: UIView {
    let headerBottomAnchor: NSLayoutYAxisAnchor
    
    typealias VMInput = DicesPlayerViewModelInput
    typealias VMOutput = DicesPlayerViewModelOutput
    private let disposeBag = DisposeBag()
    private let viewModel: DicesPlayerViewModelInterface
    private weak var delegate: DicesPlayerViewDelegate?
    private let statusView = DicesPlayerStatusView()
    private let button: AnimatedButtonView
    private let scoreView = DicesScoreView()

    init(viewModel: DicesPlayerViewModelInterface, delegate: DicesPlayerViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        self.button = AnimatedButtonView(text: .init(string: viewModel.viewData.name, attributes: ViewConstants.highlightedLabelAttributes), animation: .outlinedButton, backgroundColor: Colors.background)
        
        headerBottomAnchor = button.bottomAnchor
        
        super.init(frame: .zero)
        
        layout()
        setupBindings()
        viewModel.input.accept(.viewDidLoad(.init()))
    }
        
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([statusView, button, scoreView])
        [statusView, button, scoreView].disableAutoresizingMask()
        
        [statusView.leadingAnchor.constraint(equalTo: leadingAnchor),
         statusView.trailingAnchor.constraint(equalTo: trailingAnchor),
         statusView.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        [button.leadingAnchor.constraint(equalTo: leadingAnchor),
         button.trailingAnchor.constraint(equalTo: trailingAnchor),
         button.topAnchor.constraint(equalTo: statusView.bottomAnchor)].activate()
        
        [scoreView.leadingAnchor.constraint(equalTo: leadingAnchor),
         scoreView.trailingAnchor.constraint(equalTo: trailingAnchor),
         scoreView.topAnchor.constraint(equalTo: button.bottomAnchor),
         scoreView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
    
    private func setupBindings() {
        button.output.asObservable().filterByAssociatedType(AnimatedButtonOutput.TappedModel.self)
            .map { _ in VMInput.addScoreTapped(.init()) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)

        viewModel.output.asObservable().filterByAssociatedType(VMOutput.ShowInputPopoverModel.self)
            .append(weak: self)
            .flatMapFirst { view, output -> Observable<Int?> in
                guard let delegate = view.delegate else { return .empty() }
                return delegate.showAddScoreView(for: output.inputPopoverViewModel)
            }.compactMap { $0 }
            .map { VMInput.addScore(.init(score: $0)) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.ScoreChangedModel.self)
            .append(weak: self)
            .subscribe(onNext: { view, output in
                view.scoreView.changeScore(to: output.stepScore)
            }).disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.BecomedCurrentPlayerModel.self)
            .map { _ in AnimatedButtonInput.animate(.init()) }
            .bind(to: button.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.ResignedCurrentPlayerModel.self)
            .map { _ in AnimatedButtonInput.stopAnimating(.init()) }
            .bind(to: button.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable().filterByAssociatedType(VMOutput.NewStatusModel.self)
            .map { DicesPlayerStatusViewInput.addStatus(.init(status: $0.status, duration: $0.duration)) }
            .bind(to: statusView.input)
            .disposed(by: disposeBag)
    }
}

extension DicesPlayerView {
    struct ViewData {
        let name: String
    }
}
