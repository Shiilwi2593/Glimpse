//
//  FriendRequestsViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 09/09/2024.
//

import UIKit

class FriendRequestsViewController: UIViewController {
    
    private var viewmodel = FriendsViewModel()
    var onFriendRequestAccepted: (() -> Void)?

    
    //MARK: - UI
    private let frRequestTableVw: UITableView = {
        let frRequestTableVw = UITableView()
        frRequestTableVw.translatesAutoresizingMaskIntoConstraints = false
        frRequestTableVw.register(FriendRequestCell.self, forCellReuseIdentifier: "FriendRequestCell")
        return frRequestTableVw
    }()
    
    private let noFriendRequest: UILabel = {
        let noResultLbl = UILabel()
        noResultLbl.translatesAutoresizingMaskIntoConstraints = false
        noResultLbl.text = "No friend requests"
        noResultLbl.textColor = .gray
        noResultLbl.isHidden = true
        noResultLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return noResultLbl
    }()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUp()
        viewmodel.fetchFriendRequest()
        viewmodel.onFriendRequest = {
            if self.viewmodel.friendRequest.count == 0{
                self.noFriendRequest.isHidden = false
            }
            self.frRequestTableVw.reloadData()
            print("Friend request reload")
        }
    }
    
    //MARK: - SetUp
    private func setUp() {
        view.addSubview(frRequestTableVw)
        view.addSubview(noFriendRequest)
        
        frRequestTableVw.dataSource = self
        frRequestTableVw.delegate = self
        
        NSLayoutConstraint.activate([
            frRequestTableVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            frRequestTableVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            frRequestTableVw.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            frRequestTableVw.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            noFriendRequest.centerXAnchor.constraint(equalTo: frRequestTableVw.centerXAnchor),
            noFriendRequest.centerYAnchor.constraint(equalTo: frRequestTableVw.centerYAnchor)
        ])
    }
    
}

extension FriendRequestsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.friendRequest.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as! FriendRequestCell
        
        let friendRequest = viewmodel.friendRequest[indexPath.row]
        if let friend = friendRequest["senderId"] as? [String: Any],
           let _ = friend["_id"] as? String,
           let username = friend["username"] as? String,
           let image = friend["image"] as? String,
           let email = friend["email"] as? String{
            cell.configure(image: image, username: username, email: email)
        }
        cell.acceptButton.tag = indexPath.row
        cell.acceptButton.addTarget(self, action: #selector(didTapAccept), for: .touchUpInside)
        
        cell.rejectButton.tag = indexPath.row
        cell.rejectButton.addTarget(self, action: #selector(didTapReject), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    


    @objc private func didTapAccept(_ sender: UIButton) {
        let index = sender.tag
        let data = viewmodel.friendRequest[index]
        if let sender = data["senderId"] as? [String: Any], let receiver = data["receiverId"] as? [String: Any] {
            let senderId = sender["_id"] as! String
            let receiverId = receiver["_id"] as! String
            viewmodel.addToFriendList(id1: senderId, id2: receiverId)
            viewmodel.removeFriendRequest(requestid: data["_id"] as! String)
            
            // Cập nhật bảng ngay lập tức
            viewmodel.fetchFriendRequest()
            frRequestTableVw.reloadData()
            
            // Thông báo cho FriendsViewController và đóng sheet
            onFriendRequestAccepted?()
            dismiss(animated: true, completion: nil)
            let vc = FriendsViewController()
            navigationController?.pushViewController(vc, animated: true)
            navigationController?.navigationItem.hidesBackButton = true
        }
    }

    @objc private func didTapReject(_ sender: UIButton) {
        let index = sender.tag
        let data = viewmodel.friendRequest[index]
        viewmodel.removeFriendRequest(requestid: data["_id"] as! String)
        
        // Cập nhật bảng ngay lập tức
        viewmodel.fetchFriendRequest() // Đảm bảo rằng bạn cập nhật danh sách yêu cầu bạn bè
        frRequestTableVw.reloadData()
    }
}
