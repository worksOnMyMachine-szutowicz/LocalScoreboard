//
//  NewPlayerViewFactory.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

protocol NewGameViewFactoryInterface {
    func createNewPlayerView(viewModel: NewPlayerViewModel) -> NewPlayerView
}

class NewGameViewFactory: NewGameViewFactoryInterface {
    func createNewPlayerView(viewModel: NewPlayerViewModel) -> NewPlayerView {
        NewPlayerView(viewModel: viewModel)
    }
}
