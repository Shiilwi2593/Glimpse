//
//  FriendRequestCell.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 09/09/2024.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    
    // UI elements
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    let acceptButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("V", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.backgroundColor = .green.withAlphaComponent(0.2)
        button.layer.cornerRadius = 4
        return button
    }()
    
    let rejectButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("X", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.backgroundColor = .red.withAlphaComponent(0.2)
        button.layer.cornerRadius = 4
        return button
    }()
    
    // Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setup UI
    private func setupUI() {
        contentView.addSubview(usernameLabel)
        contentView.addSubview(acceptButton)
        contentView.addSubview(rejectButton)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            usernameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            acceptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            acceptButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rejectButton.trailingAnchor.constraint(equalTo: acceptButton.leadingAnchor, constant: -8),
            rejectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: 40),
            rejectButton.heightAnchor.constraint(equalToConstant: 30),
            
            rejectButton.widthAnchor.constraint(equalToConstant: 40),
            rejectButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
}
