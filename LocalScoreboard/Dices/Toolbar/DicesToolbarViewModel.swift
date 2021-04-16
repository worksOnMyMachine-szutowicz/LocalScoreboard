//
//  DicesToolbarViewModel.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 06/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import RxSwift
import RxCocoa

class DicesToolbarViewModel: RxInputOutput<DicesToolbarViewModelInput, DicesToolbarViewModelOutput>, DicesToolbarViewModelInterface {
    private var phaseOneToolbar: [ButtonViewData] = [.init(title: "1000dices.toolbar.addScore".localized, type: .add), .init(title: "1000dices.toolbar.nextPlayer".localized, type: .next)]
    private var phaseTwoToolbar: [ButtonViewData] = [.init(title: "1000dices.toolbar.addScore".localized, type: .add), .init(title: "1000dices.toolbar.punishment".localized, type: .punishment), .init(title: "1000dices.toolbar.nextPlayer".localized, type: .next)]
    
    override init() {
        super.init()
        
        setupBindings()
    }
    
    private func setupBindings() {
        input.asObservable().filterByAssociatedType(Input.RefreshModel.self)
            .append(weak: self)
            .map { vm, input in
                switch input.gamePhase {
                case .phaseOne:
                    return vm.phaseOneToolbar
                case .phaseTwo:
                    return vm.phaseTwoToolbar
                }
            }.map { Output.refresh(.init(buttons: $0)) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.AddTappedModel.self)
            .map { _ in Output.add(.init()) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.PunishmentTappedModel.self)
            .map { _ in Output.punishment(.init()) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
        
        input.asObservable().filterByAssociatedType(Input.NextTappedModel.self)
            .map { _ in Output.next(.init()) }
            .bind(to: outputRelay)
            .disposed(by: disposeBag)
    }
}


extension DicesToolbarViewModel {
    struct ButtonViewData {
        enum ButtonType {
            case add
            case punishment
            case next
        }
        let title: String
        let type: ButtonType
    }
}
