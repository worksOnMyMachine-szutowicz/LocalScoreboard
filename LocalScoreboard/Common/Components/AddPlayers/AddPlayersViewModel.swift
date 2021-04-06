//
//  AddPlayersViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 29/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class AddPlayersViewModel: RxInputOutput<AddPlayersViewModelInput, AddPlayersViewModelOutput>, AddPlayersViewModelInterface {
    private let requiredPlayers: Int
    private var players: [Observable<NewPlayerViewModelOutput.ValidationResultModel>] = []
    
    init(requiredPlayers: Int) {
        self.requiredPlayers = requiredPlayers
        
        super.init()
        
        setupBindigs()
    }
    
    private func setupBindigs() {
        input.asObservable().filterByAssociatedType(Input.AddRequiredPlayersModel.self)
            .append(weak: self)
            .map { vm, _ -> [Observable<NewPlayerViewModel>] in
                var newPlayers: [Observable<NewPlayerViewModel>] = []
                for _ in 0..<vm.requiredPlayers {
                    let newPlayer = vm.createAndBindNewPlayerViewModel(canBeDeleted: false)
                    newPlayers.append(Observable.just(newPlayer))
                }
                return newPlayers
            }
            .flatMapFirst { Observable.merge($0) }
            .map { Output.addPlayer(.init(newPlayerViewModel: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.AddPlayerTappedModel.self)
            .append(weak: self)
            .map { vm, _ in vm.createAndBindNewPlayerViewModel(canBeDeleted: true) }
            .map { Output.addPlayer(.init(newPlayerViewModel: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.ValidateModel.self)
            .append(weak: self)
            .flatMapLatest { vm, _ in
                Observable.zip(vm.players)
            }
            .filter { $0.allSatisfy { $0.result } }
            .map { $0.map { $0.userInput } }
            .map { Output.validationSuccess(.init(players: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
    
    private func createAndBindNewPlayerViewModel(canBeDeleted: Bool) -> NewPlayerViewModel {
        let newPlayerViewModel = NewPlayerViewModel(index: players.count, canBeDeleted: canBeDeleted)
        let newPlayerValidationResult = PublishSubject<NewPlayerViewModelOutput.ValidationResultModel>()
        players.append(newPlayerValidationResult.asObservable())
        
        newPlayerViewModel.output.asObservable().filterByAssociatedType(NewPlayerViewModelOutput.DeleteModel.self)
            .append(weak: self)
            .do { vm, output in vm.players.remove(at: output.index) }
            .map { Output.deletePlayer(.init(index: $0.1.index)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        outputRelay.asObservable().filterByAssociatedType(Output.DeletePlayerModel.self)
            .append(weak: newPlayerViewModel)
            .filter { newPlayerViewModel, deleletePlayerModel in newPlayerViewModel.viewData.index > deleletePlayerModel.index }
            .map { _ in NewPlayerViewModelInput.updateIndex(.init()) }
            .bind(to: newPlayerViewModel.input)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.ValidateModel.self)
            .map { _ in NewPlayerViewModelInput.validate(.init()) }
            .bind(to: newPlayerViewModel.input)
            .disposed(by: disposeBag)
        
        newPlayerViewModel.output.asObservable().filterByAssociatedType(NewPlayerViewModelOutput.ValidationResultModel.self)
            .bind(to: newPlayerValidationResult)
            .disposed(by: disposeBag)
        
        return newPlayerViewModel
    }
}
