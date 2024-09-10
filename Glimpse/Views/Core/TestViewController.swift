//
//  TestViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 03/09/2024.
//

import UIKit

class TestViewController: UIViewController {

    //MARK: -UI
    private let avatarImg: UIImageView = {
        let avatarImg = UIImageView()
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        avatarImg.contentMode = .scaleAspectFill
        return avatarImg
    }()
    
    private let usernameLbl: UILabel = {
       let username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return username
    }()
    
    private let friendBtn: UIButton = {
        let friendBtn = UIButton()
        friendBtn.translatesAutoresizingMaskIntoConstraints = false
        friendBtn.setTitle("Add Friend", for: .normal)
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "person.fill.badge.plus")
        config.imagePlacement = .leading
        config.imagePadding = 6
        config.baseBackgroundColor = UIColor(hex: "58BED5")
        friendBtn.configuration = config
        return friendBtn
    }()
    
    private let messageBtn: UIButton = {
        let messageBtn = UIButton()
        messageBtn.translatesAutoresizingMaskIntoConstraints = false
        messageBtn.configuration = UIButton.Configuration.bordered()
        messageBtn.configuration?.image = UIImage(systemName: "envelope")
        messageBtn.configuration?.baseForegroundColor = UIColor.black
        messageBtn.configuration?.baseBackgroundColor = UIColor(hex: "F6F6F6")
        let buttonSize: CGFloat = 50
        messageBtn.layer.cornerRadius = buttonSize / 2
        messageBtn.clipsToBounds = true
        return messageBtn
    }()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray5
        return divider
        
    }()
    
    private let postsLbl: UILabel = {
        let postsLbl = UILabel()
        postsLbl.translatesAutoresizingMaskIntoConstraints = false
        postsLbl.text = "Posts"
        postsLbl.textColor = .systemGray3
        return postsLbl
    }()
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUp()

    }
    //MARK: -SetUp
    private func setUp(){
        view.addSubview(avatarImg)
        view.addSubview(usernameLbl)
        view.addSubview(friendBtn)
        view.addSubview(messageBtn)
        view.addSubview(divider)
        view.addSubview(postsLbl)
        
        let avatarSize: CGFloat = 130
        avatarImg.layer.cornerRadius = avatarSize/2
        avatarImg.clipsToBounds = true
        
        self.avatarImg.image = UIImage(named: "jiwon")
//        self.avatarImg.downloaded(from: "https://i.ibb.co/jggwqDf/defaultavatar.jpg")
        usernameLbl.text = "@Shiilwi2593"

        
        NSLayoutConstraint.activate([
            avatarImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImg.widthAnchor.constraint(equalToConstant: 130),
            avatarImg.heightAnchor.constraint(equalToConstant: 130),
            
            usernameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLbl.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: 18),
            usernameLbl.heightAnchor.constraint(equalToConstant: 20),
            
            friendBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            friendBtn.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 18),
            friendBtn.widthAnchor.constraint(equalToConstant: 138),
            friendBtn.heightAnchor.constraint(equalToConstant: 50),
            
            messageBtn.leadingAnchor.constraint(equalTo: friendBtn.trailingAnchor, constant: 14),
            messageBtn.centerYAnchor.constraint(equalTo: friendBtn.centerYAnchor),
            messageBtn.widthAnchor.constraint(equalToConstant: 50),
            messageBtn.heightAnchor.constraint(equalToConstant: 50),
            
            divider.topAnchor.constraint(equalTo: friendBtn.bottomAnchor, constant: 24),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            postsLbl.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15),
            postsLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postsLbl.heightAnchor.constraint(equalToConstant: 15)

            
        ])
    }
    

    

}
