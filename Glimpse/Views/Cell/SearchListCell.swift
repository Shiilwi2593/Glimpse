//
//  SearchListCellTableViewCell.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 10/09/2024.
//

import UIKit

class SearchListCell: UITableViewCell {
    
    //MARK: -UI
    private let profileImgView: UIImageView = {
        let profileImgView = UIImageView()
        profileImgView.translatesAutoresizingMaskIntoConstraints = false
        profileImgView.contentMode = .scaleAspectFill
        profileImgView.clipsToBounds = true
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImgView)
        contentView.addSubview(usernameLbl)
        contentView.addSubview(emailLbl)
        
        profileImgView.layer.cornerRadius = profileImgView.frame.height / 2
        profileImgView.clipsToBounds = true
        
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
            
        ])
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: String ,username: String, email: String){
        DispatchQueue.main.async {
            self.usernameLbl.text = username
            self.emailLbl.text = email
            self.profileImgView.downloaded(from: image, contentMode: .scaleAspectFill)
            self.profileImgView.layer.cornerRadius = self.profileImgView.frame.height / 2
            self.profileImgView.clipsToBounds = true
        }
    }
    
}
