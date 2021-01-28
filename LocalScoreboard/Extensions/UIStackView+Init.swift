//
// Created by Krystian Szutowicz-EXT on 28/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init(type: StackType) {
        self.init(frame: .zero)
        alignment = .fill
        distribution = .fill

        switch type {
        case .verticalWithDefaultSpacing:
            axis = .vertical
            spacing = Values.defaultSpacing
        }
    }

    enum StackType {
        case verticalWithDefaultSpacing
    }

    struct Values {
        static let defaultSpacing: CGFloat = 20
    }
}