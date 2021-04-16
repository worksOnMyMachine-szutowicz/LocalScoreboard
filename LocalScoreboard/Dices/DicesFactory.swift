//
//  DicesFactory.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 08/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

protocol DicesFactoryInterface {
    func createBoardView(viewModel: DicesBoardViewModelInterface, delegate: DicesPlayerViewDelegate) -> DicesBoardView
    func createToolbarView(viewModel: DicesToolbarViewModelInterface) -> DicesToolbarView
    func createPlayerView(viewModel: DicesPlayerViewModelInterface, delegate: DicesPlayerViewDelegate) -> DicesPlayerView
}

class DicesFactory: DicesFactoryInterface {
    func createBoardView(viewModel: DicesBoardViewModelInterface, delegate: DicesPlayerViewDelegate) -> DicesBoardView {
        .init(viewModel: viewModel, viewFactory: self, delegate: delegate)
    }
    
    func createToolbarView(viewModel: DicesToolbarViewModelInterface) -> DicesToolbarView {
        .init(viewModel: viewModel)
    }
    
    func createPlayerView(viewModel: DicesPlayerViewModelInterface, delegate: DicesPlayerViewDelegate) -> DicesPlayerView {
        .init(viewModel: viewModel, delegate: delegate)
    }
}
