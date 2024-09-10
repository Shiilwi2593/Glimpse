//
//  SearchListCellTableViewCell.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 10/09/2024.
//

import UIKit

class SearchListCell: UITableViewCell {
    
    //MARK: -UI
    let addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let friendNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(addFriendButton)
        contentView.addSubview(friendNameLabel)
        
        NSLayoutConstraint.activate([
            friendNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            friendNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            friendNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            addFriendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            addFriendButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            addFriendButton.widthAnchor.constraint(equalToConstant: 60),
            addFriendButton.heightAnchor.constraint(equalToConstant: 30),
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
