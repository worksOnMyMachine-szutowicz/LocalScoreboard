//
//  NewPlayerView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit
import RxSwift

class NewPlayerView: UIView {
    typealias VMInput = NewPlayerViewModelInput
    private let disposeBag = DisposeBag()
    private let viewModel: NewPlayerViewModelInterface
    private let viewFactory: NewGameViewFactoryInterface
    private let describedTextField: DescribedTextFieldView
    private let deleteButton = UIButton(type: .system)
    
    init(viewModel: NewPlayerViewModelInterface, viewFactory: NewGameViewFactoryInterface) {
        self.viewModel = viewModel
        self.viewFactory = viewFactory
        
        describedTextField = viewFactory.createDescribedTextFieldView(viewModel: viewModel.viewData.descibedTextFieldViewModel)
        deleteButton.setTitle("newGame.addPlayer.delete".localized, for: .normal)
        deleteButton.titleLabel?.font = Values.deleteButtonFont
        deleteButton.isHidden = !viewModel.viewData.canBeDeleted
        
        super.init(frame: .zero)
        
        layout()
        setupBindigs()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([describedTextField, deleteButton])
        [describedTextField, deleteButton].disableAutoresizingMask()
        
        heightAnchor.constraint(equalTo: describedTextField.heightAnchor).isActive = true
        
        [describedTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
         describedTextField.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -ViewConstants.padding),
         describedTextField.topAnchor.constraint(equalTo: topAnchor),].activate()
        
        [deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -ViewConstants.padding),
         deleteButton.widthAnchor.constraint(equalToConstant: Values.deletebuttonWidth),
         deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor)].activate()
    }
    
    private func setupBindigs() {
        deleteButton.rx.tap
            .map { _ in VMInput.deleteTapped(.init()) }
            .bind(to: viewModel.input)
            .disposed(by: disposeBag)
    }
}

extension NewPlayerView {
    struct Values {
        static let deleteButtonFont: UIFont = .systemFont(ofSize: 25)
        static let deletebuttonWidth: CGFloat = 30
    }
}
