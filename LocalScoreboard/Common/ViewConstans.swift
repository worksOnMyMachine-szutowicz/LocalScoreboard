//
// Created by Krystian Szutowicz-EXT on 28/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

struct ViewConstants {
    static let backgroundLineSize: CGFloat = 1
    static let backgroundGridSize: CGFloat = 20
    static let defaultSheetMargin: CGFloat = 80
    static let sheetMarginPadding: CGFloat = defaultSheetMargin + padding
    static let sheetMarginDoublePadding: CGFloat = defaultSheetMargin + 2 * padding
    
    static let gridPadding: CGFloat = backgroundGridSize
    static let padding: CGFloat = 10
    static let animationTime: TimeInterval = 0.25
    
    static let labelAttributes: [NSAttributedString.Key : Any] =
        [.font: UIFont(name: "MarkerFelt-Thin", size: 18.416) as Any,
         .foregroundColor: Colors.labelText]
    
    static let highlightedLabelAttributes : [NSAttributedString.Key : Any] =
        [.font: UIFont(name: "MarkerFelt-Wide", size: 25) as Any,
         .foregroundColor: Colors.labelText]
}

struct Colors {
    static let background = UIColor(red: 0.988, green: 0.972, blue: 0.929, alpha: 1.0)
    static let backgroundLine = UIColor(red: 0.427, green: 0.584, blue: 0.858, alpha: 1.0)
    static let backgroundHighlight = UIColor(red: 0.961, green: 0.768, blue: 0.839, alpha: 1.0)
    
    static let labelText = UIColor(red: 0.114, green: 0.172, blue: 0.549, alpha: 1.0)
    static let errorLabelText = UIColor(red: 0.961, green: 0.768, blue: 0.839, alpha: 1.0)
}
