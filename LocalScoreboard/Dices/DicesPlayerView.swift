//
//  DicesPlayerView.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 08/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class DicesPlayerView: UIView {
    let headerBottomAnchor: NSLayoutYAxisAnchor
    private let viewModel: DicesPlayerViewModelInterface
    private let button: UIButton
    private let scoreView = UIView()
    
    init(viewModel: DicesPlayerViewModelInterface) {
        self.viewModel = viewModel
        button =  UIButton.stickerButton(title: viewModel.viewData.name)
        headerBottomAnchor = button.bottomAnchor
        
        super.init(frame: .zero)
        
        scoreView.backgroundColor = .green
        
        layout()
    }
        
    required init?(coder: NSCoder) {
        nil
    }
    
    private func layout() {
        addSubviews([button, scoreView])
        [button, scoreView].disableAutoresizingMask()
        
        [button.leadingAnchor.constraint(equalTo: leadingAnchor),
         button.widthAnchor.constraint(greaterThanOrEqualToConstant: Values.scoreWidth),
         button.trailingAnchor.constraint(equalTo: trailingAnchor),
         button.topAnchor.constraint(equalTo: topAnchor)].activate()
        
        [scoreView.centerXAnchor.constraint(equalTo: centerXAnchor),
         scoreView.widthAnchor.constraint(equalToConstant: Values.scoreWidth),
         scoreView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: ViewConstants.gridPadding),
         scoreView.bottomAnchor.constraint(equalTo: bottomAnchor)].activate()
    }
}

extension DicesPlayerView {
    private struct Values {
        static let scoreWidth: CGFloat = 40
    }
    struct ViewData {
        let name: String
    }
}
