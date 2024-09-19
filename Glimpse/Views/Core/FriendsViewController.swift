//
//  FriendsViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 25/08/2024.
//

import UIKit

class FriendsViewController: UIViewController {
    
    private let viewModel = FriendsViewModel()
    
    // MARK: - UI
    private let searchInput: UITextField = {
        let search = UITextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.borderStyle = .roundedRect
        search.placeholder = "Find your friend..."
        search.layer.cornerRadius = 10
        search.layer.masksToBounds = true
        search.layer.borderWidth = 1
        search.layer.borderColor = UIColor.systemGray6.cgColor
        return search
    }()
    
    private let friendListLbl: UILabel = {
        let friendListLbl = UILabel()
        friendListLbl.translatesAutoresizingMaskIntoConstraints = false
        friendListLbl.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        friendListLbl.text = "Friend lists"
        return friendListLbl
    }()
    
    private let friendsLstTableVw: UITableView = {
        let friendsLstTableVw = UITableView()
        friendsLstTableVw.translatesAutoresizingMaskIntoConstraints = false
        friendsLstTableVw.register(FriendCell.self, forCellReuseIdentifier: "FriendCell")
        return friendsLstTableVw
    }()
    
    private let noResultLbl: UILabel = {
        let noResultLbl = UILabel()
        noResultLbl.translatesAutoresizingMaskIntoConstraints = false
        noResultLbl.text = "This account has no friends"
        noResultLbl.isHidden = true
        noResultLbl.textColor = .gray
        noResultLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return noResultLbl
    }()
    
    private let addFrBtn: UIButton = {
        let addFrBtn = UIButton(type: .custom)
        addFrBtn.setImage(UIImage(systemName: "person.badge.plus")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        addFrBtn.translatesAutoresizingMaskIntoConstraints = false
        return addFrBtn
        
    }()
    
    private let envelopeBtn: UIButton = {
        let envelopeBtn = UIButton(type: .custom)
        envelopeBtn.setImage(UIImage(systemName: "envelope")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        envelopeBtn.translatesAutoresizingMaskIntoConstraints = false
        return envelopeBtn
    }()
    
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = false
        title = "Friends"
        setup()
        setupFriendListVw()
        viewModel.fetchFriends()
        viewModel.onFriendsUpdated = {
            self.friendsLstTableVw.reloadData()
        }
        viewWillAppear(true)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        viewModel.fetchFriends()
      
        viewModel.fetchFriendRequest()
        viewModel.onFriendRequest = {
            if self.viewModel.friendRequest.count > 0 {
                self.envelopeBtn.setImage(UIImage(systemName: "envelope.badge")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
            } else {
                self.envelopeBtn.setImage(UIImage(systemName: "envelope")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
            }
        }
       
        friendsLstTableVw.reloadData()
    }
    
    // MARK: - Setup
    private func setup() {
        view.addSubview(friendListLbl)
        view.addSubview(noResultLbl)
        view.addSubview(addFrBtn)
        view.addSubview(envelopeBtn)
        
        envelopeBtn.addTarget(self, action: #selector(didTapEnvelopeBtn), for: .touchUpInside)
        addFrBtn.addTarget(self, action: #selector(didtapAddFrBtn), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            friendListLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            friendListLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            friendListLbl.heightAnchor.constraint(equalToConstant: 15),
            
            addFrBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            addFrBtn.centerYAnchor.constraint(equalTo: friendListLbl.centerYAnchor),
            addFrBtn.heightAnchor.constraint(equalToConstant: 44),
            addFrBtn.widthAnchor.constraint(equalToConstant: 44),
            
            envelopeBtn.trailingAnchor.constraint(equalTo: addFrBtn.leadingAnchor, constant: 0),
            envelopeBtn.centerYAnchor.constraint(equalTo: friendListLbl.centerYAnchor),
            envelopeBtn.heightAnchor.constraint(equalToConstant: 44),
            envelopeBtn.widthAnchor.constraint(equalToConstant: 44),
            
            noResultLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noResultLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    
    private func setupFriendListVw() {
        view.addSubview(friendsLstTableVw)
        
        friendsLstTableVw.dataSource = self
        friendsLstTableVw.delegate = self
        
        NSLayoutConstraint.activate([
            friendsLstTableVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 13),
            friendsLstTableVw.topAnchor.constraint(equalTo: friendListLbl.bottomAnchor, constant: 10),
            friendsLstTableVw.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            friendsLstTableVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13)
        ])
    }
    
    
    @objc private func didTapEnvelopeBtn() {
        let friendRequestViewController = FriendRequestsViewController()
        if let sheet = friendRequestViewController.sheetPresentationController{
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(friendRequestViewController, animated: true)
    }
    
    @objc private func didtapAddFrBtn() {
        let addFriendViewController = AddFriendViewController()
        navigationController?.pushViewController(addFriendViewController, animated: true)
    }
}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendCell
        let friends = viewModel.friends[indexPath.row]
        if let username = friends["username"] as? String,
           let email = friends["email"] as? String,
           let image = friends["image"] as? String {
            cell.configure(image: image, username: username, email: email)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
        } else {
            print("Missing or invalid data for username, email, or image")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friends = viewModel.friends[indexPath.row]
        let id = friends["_id"]
        let vc = OrtherAccountViewController(id: id as! String)
        if let sheet = vc.sheetPresentationController{
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 30
        }
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    @objc private func didTapAddFriend(_ sender: UIButton) {
        let friendIndex = sender.tag
        let friend = viewModel.friends[friendIndex]
        print("Add friend tapped for: \(friend["username"] ?? "unknown")")
    }
}
