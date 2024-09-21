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
        searchLstTableVw.separatorInset = .zero
        searchLstTableVw.layoutMargins = .zero
        return searchLstTableVw
    }()
    
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    private let noResultLbl: UILabel = {
        let noResultLbl = UILabel()
        noResultLbl.translatesAutoresizingMaskIntoConstraints = false
        noResultLbl.text = "No results found"
        noResultLbl.isHidden = true
        noResultLbl.textColor = .gray
        noResultLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return noResultLbl
    }()
    
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setUp()
    }
    
    
    //MARK: SetUp
    private func setUp(){
        view.addSubview(searchInput)
        view.addSubview(searchBtn)
        view.addSubview(searchLstTableVw)
        view.addSubview(activityIndicator)
        view.addSubview(noResultLbl)
        
        
        searchLstTableVw.delegate = self
        searchLstTableVw.dataSource = self
        
        searchBtn.addTarget(self, action: #selector(didTapSearchBtn), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            searchInput.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            searchInput.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 10),
            searchInput.widthAnchor.constraint(equalToConstant: 320),
            searchInput.heightAnchor.constraint(equalToConstant: 44),
            
            searchBtn.leadingAnchor.constraint(equalTo: searchInput.trailingAnchor, constant: -5),
            searchBtn.centerYAnchor.constraint(equalTo: searchInput.centerYAnchor),
            searchBtn.widthAnchor.constraint(equalToConstant: 50),
            searchBtn.heightAnchor.constraint(equalToConstant: 50),
            
            searchLstTableVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchLstTableVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchLstTableVw.topAnchor.constraint(equalTo: searchInput.bottomAnchor,constant: 15),
            searchLstTableVw.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            noResultLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noResultLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    //MARK: -Action Function
    @objc private func didTapSearchBtn() {
        let keyword = searchInput.text ?? ""
        
        activityIndicator.startAnimating()
        
        frVM.searchLst.removeAll()
        searchLstTableVw.reloadData()
        searchLstTableVw.isHidden = true
        noResultLbl.isHidden = true
        
        self.frVM.findUserByKeyword(keyword: keyword)
        
        let loadingTimeout: TimeInterval = 2.0
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        timer.schedule(deadline: .now() + loadingTimeout)
        timer.setEventHandler {
            DispatchQueue.main.async {
                if self.frVM.searchLst.isEmpty {
                    self.activityIndicator.stopAnimating()
                    self.noResultLbl.isHidden = false
                }
                timer.cancel()
            }
        }
        timer.resume()
        
        self.frVM.onSearchLstUpdated = {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                
                if self.frVM.searchLst.isEmpty {
                    self.noResultLbl.isHidden = false
                } else {
                    self.noResultLbl.isHidden = true
                    self.searchLstTableVw.isHidden = false
                    UIView.performWithoutAnimation {
                        self.searchLstTableVw.reloadData()
                    }
                }
            }
        }
    }
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

extension AddFriendViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frVM.searchLst.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchLstCell", for: indexPath) as! SearchListCell
        let searchLst = frVM.searchLst[indexPath.row]
        
        if let username = searchLst["username"] as? String,
           let email = searchLst["email"] as? String,
           let image = searchLst["image"] as? String {
            cell.configure(image: image, username: username, email: email)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        } else {
            print("Missing or invalid data for username, email, or image")
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let searchLst = self.frVM.searchLst[indexPath.row]
        let id = searchLst["_id"]
        
        frVM.isMe(id: id as! String) { isMe in
            DispatchQueue.main.async {
                var vc: UIViewController
                if isMe {
                    print("Navigating to AccountViewController")
                    vc = AccountViewController()
                } else {
                    print("Navigating to OrtherAccountViewController")
                    vc = OrtherAccountViewController(id: id as! String)
                }
                
                if let sheet = vc.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.prefersGrabberVisible = true
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.preferredCornerRadius = 30
                }
                
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
