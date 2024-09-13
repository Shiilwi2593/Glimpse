//
//  AddFriendViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 07/09/2024.
//

import UIKit

class AddFriendViewController: UIViewController {
    
    var user: User?
    let frVM = FriendsViewModel()
    let mapVM = MapViewModel()
    
    
    //MARK: -UI
    private let searchInput: UITextField = {
        let search = UITextField()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.borderStyle = .roundedRect
        search.placeholder = "Find some new friends..."
        search.layer.cornerRadius = 10
        search.layer.masksToBounds = true
        search.layer.borderWidth = 1
        search.autocapitalizationType = .none
        search.layer.borderColor = UIColor.systemGray6.cgColor
        return search
    }()
    
    private let searchBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()
    
    private let searchLstTableVw: UITableView = {
        let searchLstTableVw = UITableView()
        searchLstTableVw.translatesAutoresizingMaskIntoConstraints = false
        searchLstTableVw.register(SearchListCell.self, forCellReuseIdentifier: "SearchLstCell")
        return searchLstTableVw
    }()
    
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        setUp()
    }
    
    
    //MARK: SetUp
    private func setUp(){
        view.addSubview(searchInput)
        view.addSubview(searchBtn)
        view.addSubview(searchLstTableVw)
        
        searchLstTableVw.delegate = self
        searchLstTableVw.dataSource = self
        
        searchBtn.addTarget(self, action: #selector(didTapSearchBtn), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchInput.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            searchInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            searchInput.widthAnchor.constraint(equalToConstant: 320),
            searchInput.heightAnchor.constraint(equalToConstant: 44),
            
            searchBtn.leadingAnchor.constraint(equalTo: searchInput.trailingAnchor, constant: 0),
            searchBtn.centerYAnchor.constraint(equalTo: searchInput.centerYAnchor),
            searchBtn.widthAnchor.constraint(equalToConstant: 50),
            searchBtn.heightAnchor.constraint(equalToConstant: 50),
            
            searchLstTableVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchLstTableVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            searchLstTableVw.topAnchor.constraint(equalTo: searchInput.bottomAnchor,constant: 15),
            searchLstTableVw.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }
    
    //MARK: -Action Function
    @objc private func didTapSearchBtn(){
        let keyword = searchInput.text ?? ""
        frVM.findUserByKeyword(keyword: keyword)
        frVM.onSearchLstUpdated = {
            DispatchQueue.main.async {
                UIView.performWithoutAnimation {
                    self.searchLstTableVw.reloadData()
                }
            }
        }
    }
}

extension AddFriendViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frVM.searchLst.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLstCell", for: indexPath) as! SearchListCell
        let searchLst = frVM.searchLst[indexPath.row]
        
        if let _ = UserDefaults.standard.string(forKey: "authToken") {
            mapVM.getUserInfoByToken { currentUser in
                DispatchQueue.main.async {
                    if let currentUser = currentUser, let friendId = searchLst["_id"] as? String {
                        if currentUser._id == friendId {
                            cell.addFriendButton.isHidden = true
                        } else {
                            self.frVM.isFriend(friendId: friendId) { isFriend in
                                DispatchQueue.main.async {
                                    if isFriend {
                                        cell.addFriendButton.isHidden = true
                                    } else {
                                        // Kiểm tra nếu đang pending
                                        self.frVM.isPending(receiverId: friendId) { isPending in
                                            DispatchQueue.main.async {
                                                if isPending {
                                                    cell.addFriendButton.setTitle("Pending", for: .normal)
                                                    cell.addFriendButton.backgroundColor = .systemGray5
                                                    cell.addFriendButton.isEnabled = false
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        let username = searchLst["username"] ?? "unknown"
        cell.friendNameLabel.text = "\(username)"
        cell.addFriendButton.tag = indexPath.row
        cell.addFriendButton.addTarget(self, action: #selector(didTapAddFriendBtn), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchLst = self.frVM.searchLst[indexPath.row]
        let id = searchLst["_id"]
        let vc = OrtherAccountViewController(id: id as! String)
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.preferredCornerRadius = 30
        }
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    
    
    
    @objc private func didTapAddFriendBtn(_ sender: UIButton){
        let index = sender.tag
        let receiver = frVM.searchLst[index]
        let receiverId = receiver["_id"] as! String
        frVM.sendFriendRequest(receiverId: receiverId)
        print("add button tapped")
    }
    
    
}
