//
// Created by Krystian Szutowicz-EXT on 28/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

extension UIStackView {
    convenience init(type: StackType) {
        self.init(frame: .zero)

        switch type {
        case .verticalWithoutSpacing:
            alignment = .fill
            distribution = .fillEqually
            axis = .vertical
            spacing = .zero
        case .verticalWithDefaultSpacing:
            alignment = .fill
            distribution = .fill
            axis = .vertical
            spacing = Values.defaultSpacing
        case .verticalBackground:
            alignment = .fill
            distribution = .equalCentering
            axis = .vertical
            spacing = Values.backgroundGridSpacing
        case .horizontalBackground:
            alignment = .fill
            distribution = .equalCentering
            axis = .horizontal
            spacing = Values.backgroundGridSpacing
        }
    }

    enum StackType {
        case verticalWithoutSpacing
        case verticalWithDefaultSpacing
        case verticalBackground
        case horizontalBackground
    }

    private struct Values {
        static let defaultSpacing: CGFloat = 20
        static let backgroundGridSpacing: CGFloat = 19
    }
}
