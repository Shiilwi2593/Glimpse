//
//  AccountViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 25/08/2024.
//

import UIKit

class AccountViewController: UIViewController {
    
    var user: User!
    let mapVM = MapViewModel()
    
    //MARK: - UI Elements
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
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUp()
        setUpNavigationBar()
    }
    
    //MARK: - SetUp
    private func setUp(){
        view.addSubview(avatarImg)
        view.addSubview(usernameLbl)
        view.addSubview(divider)
        view.addSubview(postsLbl)
        
        let avatarSize: CGFloat = 130
        avatarImg.layer.cornerRadius = avatarSize / 2
        avatarImg.clipsToBounds = true
        
        self.avatarImg.downloaded(from: "https://i.ibb.co/jggwqDf/defaultavatar.jpg")
        usernameLbl.text = "@Shiilwi2593"

        NSLayoutConstraint.activate([
            avatarImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            avatarImg.widthAnchor.constraint(equalToConstant: 130),
            avatarImg.heightAnchor.constraint(equalToConstant: 130),
            
            usernameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameLbl.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: 18),
            usernameLbl.heightAnchor.constraint(equalToConstant: 20),
            
            divider.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 24),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            postsLbl.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 15),
            postsLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            postsLbl.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    //MARK: - Navigation Bar Setup
    private func setUpNavigationBar() {
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.2.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .plain, target: nil, action: nil)
        menuButton.menu = createMenu()

        navigationItem.rightBarButtonItem = menuButton
    }
    
    //MARK: - Menu Creation
    private func createMenu() -> UIMenu {
        let editAction = UIAction(title: "Edit Profile", image: UIImage(systemName: "pencil")) { _ in
            self.editButtonTapped()
        }
        
        let logoutAction = UIAction(title: "Logout", image: UIImage(systemName: "arrow.right.square")) { _ in
            self.logoutButtonTapped()
        }
        
        return UIMenu(title: "", options: .displayInline, children: [editAction, logoutAction])
    }
    
    //MARK: - Actions
    @objc private func editButtonTapped() {
        print("Edit button tapped")
        // Navigate to Edit User Info screen
    }
    
    @objc private func logoutButtonTapped() {
        print("Logout button tapped")
        // Handle logout
    }
    
    //MARK: - Fetch User Info
    func fetchUserInfo() {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("Token not found in UserDefaults")
            return
        }
        
        mapVM.getUserInfoByToken(token: token) { user in
            DispatchQueue.main.async {
                if let user = user {
                    self.user = user
                    print("User info: \(user)")
                    self.avatarImg.downloaded(from: user.image ?? "https://i.ibb.co/jggwqDf/defaultavatar.jpg")
                } else {
                    print("Failed to fetch user info.")
                }
            }
        }
    }
}
