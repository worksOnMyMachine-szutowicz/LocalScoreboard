//
// Created by Krystian Szutowicz-EXT on 27/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

extension UIView {
    func addSubviewAndFillToSafeArea(_ view: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        [view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: insets.top),
         view.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: insets.left),
         view.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -insets.right),
         view.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)].activate()
    }

    func addSubviewAndFill(_ view: UIView, insets: UIEdgeInsets = .zero) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        [view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
         view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
         view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
         view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)].activate()
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach { addSubview($0) }
    }
}