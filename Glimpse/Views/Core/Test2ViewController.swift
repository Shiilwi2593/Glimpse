//
//  Test2ViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 03/09/2024.
//

import UIKit

class Test2ViewController: UIViewController {
    
    //MARK: -UI
    private let avatarImg: UIImageView = {
        let avatarImg = UIImageView()
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        avatarImg.contentMode = .scaleAspectFill
        avatarImg.layer.cornerRadius = 50 // Adjusted for a smaller, circular avatar
        avatarImg.clipsToBounds = true
        return avatarImg
    }()
    
    private let usernameLbl: UILabel = {
        let username = UILabel()
        username.translatesAutoresizingMaskIntoConstraints = false
        username.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return username
    }()
    
    private let subtitleLbl: UILabel = {
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitle.textColor = .gray
        return subtitle
    }()

    
    private let statsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        return stack
    }()
    
    private let navBar: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    private let glimpseBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Glimpse", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let friendsBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Friends", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    
    private let selectionIndicator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Friend", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.16, green: 0.5, blue: 0.73, alpha: 1.0) // Approximate color based on Glimpse's theme
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private func createStatView(value: String, label: String) -> UIView {
        let container = UIView()
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        valueLabel.textAlignment = .center
        
        let textLabel = UILabel()
        textLabel.text = label
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textLabel.textColor = .gray
        textLabel.textAlignment = .center
        
        [valueLabel, textLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: container.topAnchor),
            valueLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            textLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 4),
            textLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            textLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
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
        view.addSubview(subtitleLbl)
        view.addSubview(statsStack)
        view.addSubview(addFriendButton) // Add this line
        view.addSubview(navBar)
        
        navBar.addSubview(glimpseBtn)
        navBar.addSubview(friendsBtn)
        navBar.addSubview(selectionIndicator)
        
        self.avatarImg.image = UIImage(named: "winter")
        usernameLbl.text = "shiilwi2953"
        subtitleLbl.text = "graylwi2593@gmail.com"
        
        let glimpse = createStatView(value: "28", label: "Glimpses")
        let friends = createStatView(value: "78", label: "Friends")
        let likes = createStatView(value: "99", label: "Likes")
        
        [friends, glimpse, likes].forEach { statsStack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            avatarImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImg.widthAnchor.constraint(equalToConstant: 100),
            avatarImg.heightAnchor.constraint(equalToConstant: 100),
            
            usernameLbl.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: 16),
            usernameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 8),
            subtitleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            addFriendButton.topAnchor.constraint(equalTo: subtitleLbl.bottomAnchor, constant: 16),
            addFriendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addFriendButton.widthAnchor.constraint(equalToConstant: 180),
            addFriendButton.heightAnchor.constraint(equalToConstant: 40),
            
            statsStack.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 24),
            statsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            navBar.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 20),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: 50),
            
            glimpseBtn.leadingAnchor.constraint(equalTo: navBar.leadingAnchor),
            glimpseBtn.topAnchor.constraint(equalTo: navBar.topAnchor),
            glimpseBtn.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            glimpseBtn.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 1/3),
            
            friendsBtn.centerXAnchor.constraint(equalTo: navBar.centerXAnchor),
            friendsBtn.topAnchor.constraint(equalTo: navBar.topAnchor),
            friendsBtn.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            friendsBtn.widthAnchor.constraint(equalTo: navBar.widthAnchor, multiplier: 1/3),
            
            selectionIndicator.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            selectionIndicator.leadingAnchor.constraint(equalTo: glimpseBtn.leadingAnchor),
            selectionIndicator.widthAnchor.constraint(equalTo: glimpseBtn.widthAnchor),
            selectionIndicator.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        [glimpseBtn, friendsBtn].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        glimpseBtn.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        friendsBtn.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        addFriendButton.addTarget(self, action: #selector(addFriendTapped), for: .touchUpInside)
        
    }
    @objc private func addFriendTapped() {
        // Add friend functionality here
        print("Add friend button tapped")
    }
    
    @objc private func navButtonTapped(_ sender: UIButton) {
        [glimpseBtn, friendsBtn].forEach { $0.setTitleColor(.gray, for: .normal) }
        sender.setTitleColor(.black, for: .normal)
        
        UIView.animate(withDuration: 0.3) {
            self.selectionIndicator.frame.origin.x = sender.frame.origin.x
        }
        
    }
}

