//
//  UIButton+StickerButton.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 01/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

extension UIButton {
    static func navigationButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setAttributedTitle(.init(string: title, attributes: ViewConstants.highlightedLabelAttributes), for: .normal)
        button.backgroundColor = Colors.navigationButtonBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.backgroundLine.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: ViewConstants.padding, bottom: 0, right: ViewConstants.padding)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return button
    }
    
    static func stickerButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setAttributedTitle(.init(string: title, attributes: ViewConstants.highlightedLabelAttributes), for: .normal)
        button.backgroundColor = Colors.pointOfInterestBackground
        button.layer.borderWidth = 1
        button.layer.borderColor = Colors.backgroundLine.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: ViewConstants.padding, bottom: 0, right: ViewConstants.padding)
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return button
    }
}
