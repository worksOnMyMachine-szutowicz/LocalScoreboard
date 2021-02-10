//
//  DicesFactory.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 08/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

protocol DicesFactoryInterface {
    func createPlayerView(playerName: String) -> DicesPlayerView
}

class DicesFactory: DicesFactoryInterface {
    func createPlayerView(playerName: String) -> DicesPlayerView {
        let viewModel = DicesPlayerViewModel(viewData: .init(name: playerName))
        return .init(viewModel: viewModel)
    }
}
