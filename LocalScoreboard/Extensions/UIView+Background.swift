//
//  UIView+Background.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 01/02/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

extension UIView {
    func setSheetBackground() {
        let background = BackgroundView()
        addSubviewAndFill(background)
        sendSubviewToBack(background)
    }
}
