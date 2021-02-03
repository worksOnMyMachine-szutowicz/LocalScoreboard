//
//  RulesViewController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 30/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class RulesViewController: BackgroundedUIViewController {
    private let header: GameHeaderView
    private let sections: [TitledSectionView]
    
    init(viewData: ViewData) {
        header = .init(viewData: viewData.header)
        sections = viewData.sections.map { TitledSectionView(viewData: $0) }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        setupBackButton()
    }
    
    private func layout() {
        let stackView = UIStackView(type: .verticalWithDefaultSpacing)
        let scrollView = UIScrollView(frame: .zero)
        
        scrollView.addSubviewAndFill(stackView, insets: .init(top: Values.topMargin, left: 0, bottom: 0, right: 0))
        view.addSubviewAndFillToSafeArea(scrollView)
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        stackView.addArrangedSubview(header)
        sections.forEach { stackView.addArrangedSubview($0) }
    }
}

extension RulesViewController {
    private struct Values {
        static let topMargin: CGFloat = 60
    }
    struct ViewData {
        let header: GameHeaderView.ViewData
        let sections: [TitledSectionView.ViewData]
    }
}
