//
//  UIButton+RoundedWidth.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 16/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

extension UIButton {
    func roundWidth(to width: CGFloat) {
        let minimumWidth = Int(titleLabel?.textWidth ?? 0) + Int(width)
        let roundedWidth = CGFloat(minimumWidth + (Int(width) - (Int(minimumWidth) % Int(width))))
        widthAnchor.constraint(greaterThanOrEqualToConstant: roundedWidth).isActive = true
    }
}
