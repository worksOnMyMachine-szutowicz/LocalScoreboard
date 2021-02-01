//
// Created by Krystian Szutowicz-EXT on 28/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

struct ViewConstants {
    static let backgroundGridSize: CGFloat = 20
    static let sheetMargin: CGFloat = 80
    static let sheetMarginPadding: CGFloat = sheetMargin + padding
    
    static let padding: CGFloat = 10
    static let animationTime: TimeInterval = 0.25
    
    static let labelTextAttributes: [NSAttributedString.Key : Any] =
        [.font: UIFont(name: "MarkerFelt-Thin", size: 17) as Any,
         .foregroundColor: Colors.labelTextColor,
         .paragraphStyle: labelParagraphStyle]
    
    private static var labelParagraphStyle: NSMutableParagraphStyle {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 3
        return style
    }
}

struct Colors {
    static let background = UIColor(red: 0.988, green: 0.972, blue: 0.929, alpha: 1.0)
    static let backgroundLine = UIColor(red: 0.427, green: 0.584, blue: 0.858, alpha: 1.0)
    static let backgroundHighlight = UIColor(red: 0.961, green: 0.768, blue: 0.839, alpha: 1.0)
    
    static let labelTextColor = UIColor(red: 0.114, green: 0.172, blue: 0.549, alpha: 1.0)
}
