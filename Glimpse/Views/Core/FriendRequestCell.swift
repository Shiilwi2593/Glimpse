//
//  FriendRequestCell.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 09/09/2024.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    
    // UI elements
    private let profileImgView: UIImageView = {
        let profileImgView = UIImageView()
        profileImgView.translatesAutoresizingMaskIntoConstraints = false
        profileImgView.contentMode = .scaleToFill
        return profileImgView
    }()
    
    private let usernameLbl: UILabel = {
        let usernameLbl = UILabel()
        usernameLbl.translatesAutoresizingMaskIntoConstraints = false
        usernameLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return usernameLbl
    }()
    
    private let emailLbl: UILabel = {
        let emailLbl = UILabel()
        emailLbl.translatesAutoresizingMaskIntoConstraints = false
        emailLbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        emailLbl.textColor = .gray
        return emailLbl
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
        contentView.addSubview(profileImgView)
        contentView.addSubview(usernameLbl)
        contentView.addSubview(emailLbl)
        contentView.addSubview(acceptButton)
        contentView.addSubview(rejectButton)
        
        
        // Layout constraints
        NSLayoutConstraint.activate([
            profileImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profileImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            profileImgView.heightAnchor.constraint(equalToConstant: 50),
            profileImgView.widthAnchor.constraint(equalToConstant: 50),
            
            usernameLbl.leadingAnchor.constraint(equalTo: profileImgView.trailingAnchor, constant: 20),
            usernameLbl.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13),
            usernameLbl.heightAnchor.constraint(equalToConstant: 16),
            usernameLbl.widthAnchor.constraint(equalToConstant: 150),
            
            emailLbl.leadingAnchor.constraint(equalTo: usernameLbl.leadingAnchor),
            emailLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 8),
            emailLbl.heightAnchor.constraint(equalToConstant: 15),
            
            acceptButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            acceptButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            acceptButton.heightAnchor.constraint(equalToConstant: 38),
            acceptButton.widthAnchor.constraint(equalToConstant: 38),
            
            rejectButton.trailingAnchor.constraint(equalTo: acceptButton.leadingAnchor, constant: -8),
            rejectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            rejectButton.widthAnchor.constraint(equalToConstant: 38),
            rejectButton.heightAnchor.constraint(equalToConstant: 38),
        ])
    }
    
    func configure(image: String ,username: String, email: String){
        DispatchQueue.main.async {
            self.usernameLbl.text = username
            self.emailLbl.text = email
            self.profileImgView.downloaded(from: image, contentMode: .scaleToFill)
            self.profileImgView.layer.cornerRadius = self.profileImgView.frame.height / 2
            self.profileImgView.clipsToBounds = true
        }
    }
}
