//
//  FriendRequestsViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 09/09/2024.
//

import UIKit

class FriendRequestsViewController: UIViewController {
    
    private var viewmodel = FriendsViewModel()
    
    //MARK: - UI
    private let frRequestTableVw: UITableView = {
        let frRequestTableVw = UITableView()
        frRequestTableVw.translatesAutoresizingMaskIntoConstraints = false
        frRequestTableVw.register(FriendRequestCell.self, forCellReuseIdentifier: "FriendRequestCell")
        return frRequestTableVw
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUp()
        viewmodel.fetchFriendRequest()
        viewmodel.onFriendRequest = {
            self.frRequestTableVw.reloadData()
            print("Friend request reload")
        }
    }
    
    //MARK: - SetUp
    private func setUp() {
        view.addSubview(frRequestTableVw)
        
        frRequestTableVw.dataSource = self
        frRequestTableVw.delegate = self
        
        NSLayoutConstraint.activate([
            frRequestTableVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            frRequestTableVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            frRequestTableVw.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            frRequestTableVw.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }
    
}

extension FriendRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.friendRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as? FriendRequestCell else {
            return UITableViewCell()
        }
        
        let friendRequest = viewmodel.friendRequest[indexPath.row]
        if let friend = friendRequest["senderId"] as? [String: Any],
           let username = friend["username"] as? String {
            cell.usernameLabel.text = username
        } else {
            cell.usernameLabel.text = "Unknown"
        }
        
        cell.acceptButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(didTapAccept), for: .touchUpInside)
        
        cell.rejectButton.tag = indexPath.row
        cell.rejectButton.addTarget(self, action: #selector(didTapReject), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func didTapAccept(_ sender: UIButton) {
        let index = sender.tag
        let data = viewmodel.friendRequest[index]
        if let sender = data["senderId"] as? [String: Any] {
            let senderId = sender["_id"] as! String
            viewmodel.addToFriendList(senderId: senderId)
            viewmodel.removeFriendRequest(requestid: data["_id"] as! String)
        }
    }
    
    @objc private func didTapReject(_ sender: UIButton) {
        let index = sender.tag
        let data = viewmodel.friendRequest[index]
        viewmodel.removeFriendRequest(requestid: data["_id"] as! String)
        
    }
}
