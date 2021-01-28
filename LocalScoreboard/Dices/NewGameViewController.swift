//
// Created by Krystian Szutowicz-EXT on 26/01/2021.
// Copyright (c) 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {
    private let formView = UIStackView(type: .verticalWithDefaultSpacing)

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        title = "newGame.title".localized
        view.backgroundColor = .systemGroupedBackground

        layout()
    }

    private func layout() {
        view.addSubviewAndFillToSafeArea(formView, insets: Values.insets)
        formView.translatesAutoresizingMaskIntoConstraints = false

        formView.addArrangedSubview(GameHeaderView(title: "1000 Dices", description: "quite long text quite long text quite long text quite long text quite long text quite long text quite long text quite long text quite long text "))
        formView.addArrangedSubview(AddPlayersView())
    }
}

extension NewGameViewController {
    struct Values {
        static let insets: UIEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
    }
}