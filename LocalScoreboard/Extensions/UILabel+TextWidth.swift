//
//  UILabel+TextWidth.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 05/04/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

extension UILabel {
    var textWidth: CGFloat {
        guard let nsString = text as NSString? else { return 0 }
        
        let rect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let labelSize = nsString.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font as Any], context: nil)
        
        return labelSize.width
    }
}
