//
//  NewPlayerViewFactory.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

protocol NewGameViewFactoryInterface {
    func createNewPlayerView(viewModel: NewPlayerViewModelInterface, viewFactory: NewGameViewFactoryInterface) -> NewPlayerView
    func createDescribedTextFieldView(viewModel: DescribedTextFieldViewModelInterface) -> DescribedTextFieldView
}

class NewGameViewFactory: NewGameViewFactoryInterface {
    func createNewPlayerView(viewModel: NewPlayerViewModelInterface, viewFactory: NewGameViewFactoryInterface) -> NewPlayerView {
        NewPlayerView(viewModel: viewModel, viewFactory: viewFactory)
    }
    
    func createDescribedTextFieldView(viewModel: DescribedTextFieldViewModelInterface) -> DescribedTextFieldView {
        DescribedTextFieldView(viewModel: viewModel)
    }
}
