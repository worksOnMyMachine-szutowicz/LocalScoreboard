//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class AddPlayersView: UIView {
    typealias VMInput = AddPlayersViewModelInput
    private let disposeBag = DisposeBag()
    private let viewModel: AddPlayersViewModelInterface
    private let viewFactory: NewGameViewFactoryInterface
    private let stackView = UIStackView(type: .verticalWithDefaultSpacing)
    private let headerContainer = UIView()
    private let headerTitle = UILabel()
    private let addButton = UIButton(type: .system)

    init(viewModel: AddPlayersViewModelInterface, viewFactory: NewGameViewFactoryInterface) {
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        headerContainer.backgroundColor = Colors.pointOfInterestBackground
        headerTitle.attributedText = .init(string: "newGame.addPlayer.title".localized, attributes: ViewConstants.highlightedLabelAttributes)
        addButton.setAttributedTitle(.init(string: "newGame.addPlayer.button".localized, attributes: ViewConstants.highlightedLabelAttributes), for: .normal)
        
        super.init(frame: .zero)
        
        layout()
        setupBindigs()
        
        viewModel.input.accept(.addRequiredPlayers(.init()))
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func layout() {
        headerContainer.addSubviews([headerTitle, addButton])

        let scrollView = UIScrollView(frame: .zero)
        scrollView.addSubviewAndFill(stackView, insets: Values.scrollViewInsets)
        
        addSubviews([headerContainer, scrollView])
        [headerContainer, headerTitle, addButton, scrollView, stackView].disableAutoresizingMask()

        [headerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
        headerContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
        headerContainer.topAnchor.constraint(equalTo: topAnchor),
        headerContainer.heightAnchor.constraint(equalToConstant: Values.headerContainerHeight)].activate()

        [headerTitle.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: ViewConstants.padding),
         headerTitle.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)].activate()

        [addButton.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -ViewConstants.padding),
        addButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor)].activate()
        
        [scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
         scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
         scrollView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: ViewConstants.padding),
         scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
        
        stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupBindigs() {
        addButton.rx.tap
            .map { _ in VMInput.addPlayerTapped(.init())}
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
        
        viewModel.output.asObservable()
            .append(weak: self)
            .subscribe(onNext: { view, output in
                switch output {
                case .addPlayer(let output):
                    let playerView = view.viewFactory.createNewPlayerView(viewModel: output.newPlayerViewModel)
                    playerView.alpha = 0
                    playerView.isHidden = true
                    view.stackView.addArrangedSubview(playerView)

                    UIView.animate(withDuration: ViewConstants.animationTime, animations: { () -> Void in
                        playerView.alpha = 1
                        playerView.isHidden = false
                    })
                case .deletePlayer(let output):
                    let playerView = view.stackView.subviews[output.index]
                    playerView.alpha = 1
                    playerView.isHidden = false

                    UIView.animate(withDuration: ViewConstants.animationTime, animations: { () -> Void in
                        playerView.alpha = 0
                        playerView.isHidden = true
                    })
                    playerView.removeFromSuperview()
                case .validationSuccess:
                    break
                }
            }).disposed(by: disposeBag)
    }
}

extension AddPlayersView {
    private struct Values {
        static let headerContainerHeight: CGFloat = 2 * ViewConstants.backgroundGridSize
        static let scrollViewInsets: UIEdgeInsets = .init(top: ViewConstants.padding, left: 0, bottom: ViewConstants.padding, right: 0)
    }
}
