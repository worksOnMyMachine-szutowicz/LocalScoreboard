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
    private let button: UIButton
    private let scoreView = DicesScoreView()
    private var viewWidth: CGFloat {
        let buttonWidth = Int(button.titleLabel?.textWidth ?? 0) + Int(ViewConstants.backgroundGridSize)
        return CGFloat(buttonWidth + (Int(ViewConstants.backgroundGridSize) - (Int(buttonWidth) % Int(ViewConstants.backgroundGridSize))))
    }

    init(viewModel: DicesPlayerViewModelInterface, delegate: DicesPlayerViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        button =  UIButton.stickerButton(title: viewModel.viewData.name)
        button.layer.borderWidth = 0
        button.backgroundColor = Colors.pointOfInterestBackground
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
         button.widthAnchor.constraint(equalToConstant: viewWidth),
         button.trailingAnchor.constraint(equalTo: trailingAnchor),
         button.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        [scoreView.leadingAnchor.constraint(equalTo: leadingAnchor),
         scoreView.trailingAnchor.constraint(equalTo: trailingAnchor),
         scoreView.topAnchor.constraint(equalTo: button.bottomAnchor),
         scoreView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
    
    private func setupBindings() {
        button.rx.tap
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
    }
}

extension DicesPlayerView {
    struct ViewData {
        let name: String
    }
}
