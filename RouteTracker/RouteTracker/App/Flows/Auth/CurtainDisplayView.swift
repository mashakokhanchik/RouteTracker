//
//  CurtainDisplay.swift
//  RouteTracker
//
//  Created by Мария Коханчик on 15.11.2021.
//

import UIKit

// MARK: - Class for showing the curtain when the application leaves the photonic mode.

class CurtainDisplayView: UIView {
    
    // MARK: - Private properties
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Route Tracker"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        return label
    }()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        backgroundColor = .systemYellow
        addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            textLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
}
