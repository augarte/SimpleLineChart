//
//  File.swift
//  
//
//  Created by Aimar Ugarte on 15/1/23.
//

import UIKit

@available(iOS 13.0, *)
final class SLCEmptyState: UIView {
    
    // MARK: Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 8.0
        static let backgroundColor: UIColor = .white // UIColor.hexStringToUIColor(hex: "FF9494")
        static let textColor: UIColor = .black
        static let emptyStateTitle: String = "No data entry to display"
    }
    
    // MARK: UIVariables
    private lazy var errorLbl: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.emptyStateTitle
        label.textColor = Constants.textColor
        label.textAlignment = .center
        return label
    }()
    
    // MARK: Initialization
    init() {
        super.init(frame: CGRectZero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
}

// MARK: - View setup
private extension SLCEmptyState {
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = Constants.cornerRadius
        layer.masksToBounds = true;
        backgroundColor = Constants.backgroundColor
        addSubview(errorLbl)
        NSLayoutConstraint.activate([
            errorLbl.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorLbl.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorLbl.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorLbl.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
