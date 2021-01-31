//
//  RulesViewController.swift
//  LocalScoreboard
//
//  Created by Krystian Szutowicz-EXT on 30/01/2021.
//  Copyright © 2021 works on my machine ~Szutowicz Krystian. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
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
        view.backgroundColor = .systemGroupedBackground
        title = "rules.title".localized
        
        layout()
    }
    
    private func layout() {
        let stackView = UIStackView(type: .verticalWithDefaultSpacing)
        let scrollView = UIScrollView(frame: .zero)
        
        scrollView.addSubviewAndFill(stackView)
        view.addSubviewAndFill(scrollView)
        stackView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        stackView.addArrangedSubview(header)
        sections.forEach { stackView.addArrangedSubview($0) }
    }
}

extension RulesViewController {
    struct ViewData {
        let header: GameHeaderView.ViewData
        let sections: [TitledSectionView.ViewData]
    }
}
