//
//  OrtherAccountViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 12/09/2024.
//

import UIKit
import MapKit

class OrtherAccountViewController: UIViewController {
    
    let id: String
    
    init(id: String) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var user: User?
    let friendVM = FriendsViewModel()
    let accountVM = AccountViewModel()
    private var mapViewContainer: UIView?
    private var dimmedView: UIView?
    private var imageViewContainer: UIView?
    
    
    //MARK: -UI
    private let avatarImg: UIImageView = {
        let avatarImg = UIImageView()
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        avatarImg.contentMode = .scaleAspectFill
        avatarImg.layer.cornerRadius = 50
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
    
    private let friendsListVw: UITableView = {
        let friendsListVw = UITableView()
        friendsListVw.translatesAutoresizingMaskIntoConstraints = false
        friendsListVw.register(FriendCell.self, forCellReuseIdentifier: "FriendsListCell")
        return friendsListVw
    }()
    
    private let addFriendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 20
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add Friend", for: .normal)
        button.backgroundColor = UIColor(red: 0.16, green: 0.5, blue: 0.73, alpha: 1.0)
        return button
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
    
    private let glimpseView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionVw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVw.translatesAutoresizingMaskIntoConstraints = false
        collectionVw.backgroundColor = .white
        collectionVw.register(GlimpseCell.self, forCellWithReuseIdentifier: "GlimpseCell")
        return collectionVw
    }()
    
    private let noGlimpseLbl: UILabel = {
        let noGlimpseLbl = UILabel()
        noGlimpseLbl.translatesAutoresizingMaskIntoConstraints = false
        noGlimpseLbl.text = "This account has no glimpse"
        noGlimpseLbl.textColor = .gray
        noGlimpseLbl.isHidden = true
        noGlimpseLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return noGlimpseLbl
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
        view.backgroundColor = .white
        title = "Profile"
        setUpNavigationBar()
        friendVM.fetchUserInfoById(id: self.id){ user in
            self.user = user
            print(self.user ?? "unknown")
            DispatchQueue.main.async {
                self.setUp()
            }
        }
        self.viewWillAppear(true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        friendVM.fetchUserInfoById(id: self.id) { user in
            self.user = user
            print(self.user ?? "unknown")
            DispatchQueue.main.async {
                if let username = self.user?.username {
                    self.usernameLbl.text = username
                }
                
                if let email = self.user?.email {
                    self.subtitleLbl.text = email
                }
                
                
                self.friendVM.isFriend(friendId: self.id) { isFriend in
                    DispatchQueue.main.async {
                        if isFriend {
                            self.addFriendButton.setTitle("Friend", for: .normal)
                            self.addFriendButton.backgroundColor = UIColor(red: 0.251, green: 0.8, blue: 0.204, alpha: 1.0)
                        } else {
                            self.friendVM.isPending(receiverId: self.id) { isPending in
                                DispatchQueue.main.async {
                                    if isPending {
                                        self.addFriendButton.setTitle("Pending", for: .normal)
                                        self.addFriendButton.backgroundColor = UIColor(hex: "c35ac7")
                                    }
                                }
                            }
                        }
                        self.setupButton()
                        self.updateAddFriendButton()
                        
                    }
                }
                
                
                
                self.glimpseView.isHidden = false
                self.friendsListVw.isHidden = true
                
                self.fetchGlimpses {
                    self.createStatsViews()
                }
                
                self.friendVM.fetchFriendsById(id: self.id)
                self.friendVM.onFriendsUpdated = {
                    self.friendsListVw.reloadData()
                    print("reload friend lists")
                }
                
                self.statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
                
                
            }
        }
    }
    
    func createStatsViews() {
        
        let glimpse = self.createStatView(value: "\(self.user?.friends?.count ?? 0)", label: "Friends")
        let friends = self.createStatView(value: "\(self.accountVM.ortherGlimpse.count)", label: "Glimpse")
        
        [friends, glimpse].forEach { self.statsStack.addArrangedSubview($0) }
    }
    
    private func fetchGlimpses(completion: @escaping () -> Void) {
        let loading = UIActivityIndicatorView(style: .large)
        loading.translatesAutoresizingMaskIntoConstraints = false
        glimpseView.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.centerXAnchor.constraint(equalTo: glimpseView.centerXAnchor),
            loading.centerYAnchor.constraint(equalTo: glimpseView.centerYAnchor)
        ])
        loading.startAnimating()
        
        accountVM.fetchFriendGlimpse(id: self.id) { [weak self] in
            DispatchQueue.main.async {
                completion()
                self?.glimpseView.reloadData()
                print("Reloaded glimpse view data")
                
                if self?.accountVM.ortherGlimpse.count == 0{
                    self?.noGlimpseLbl.isHidden = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    loading.stopAnimating()
                    loading.removeFromSuperview()
                }
                
            }
        }
    }
    
    
    
    
    
    //MARK: -SetUp
    private func setUp(){
        view.addSubview(avatarImg)
        view.addSubview(usernameLbl)
        view.addSubview(subtitleLbl)
        view.addSubview(statsStack)
        view.addSubview(addFriendButton)
        view.addSubview(navBar)
        view.addSubview(friendsListVw)
        view.addSubview(glimpseView)
        view.addSubview(noResultLbl)
        view.addSubview(noGlimpseLbl)
        
        navBar.addSubview(glimpseBtn)
        navBar.addSubview(friendsBtn)
        navBar.addSubview(selectionIndicator)
        
        
        self.avatarImg.downloaded(from: (self.user?.image)!)
        
        
        if let username = self.user?.username{
            usernameLbl.text = username
        }
        
        if let email = self.user?.email{
            subtitleLbl.text = email
        }
        
        glimpseView.delegate = self
        glimpseView.dataSource = self
        
        friendsListVw.dataSource = self
        friendsListVw.delegate = self
        
        
        
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
            
            statsStack.topAnchor.constraint(equalTo: addFriendButton.bottomAnchor, constant: 22),
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
            selectionIndicator.heightAnchor.constraint(equalToConstant: 2),
            
            friendsListVw.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            friendsListVw.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            friendsListVw.topAnchor.constraint(equalTo: selectionIndicator.bottomAnchor, constant: 8),
            friendsListVw.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            glimpseView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            glimpseView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            glimpseView.topAnchor.constraint(equalTo: selectionIndicator.bottomAnchor, constant: 8),
            glimpseView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            noResultLbl.centerXAnchor.constraint(equalTo: friendsListVw.centerXAnchor),
            noResultLbl.centerYAnchor.constraint(equalTo: friendsListVw.centerYAnchor),
            
            noGlimpseLbl.centerXAnchor.constraint(equalTo: glimpseView.centerXAnchor),
            noGlimpseLbl.centerYAnchor.constraint(equalTo: glimpseView.centerYAnchor)
        ])
        
        [glimpseBtn, friendsBtn].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        glimpseBtn.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        glimpseBtn.tag = 0
        friendsBtn.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        friendsBtn.tag = 1
        
        
        
        
    }
    
    private func updateAddFriendButton() {
        friendVM.isFriend(friendId: self.id) { isFriend in
            DispatchQueue.main.async {
                if isFriend {
                    self.addFriendButton.setTitle("Friend", for: .normal)
                    self.addFriendButton.backgroundColor = UIColor(red: 0.251, green: 0.8, blue: 0.204, alpha: 1.0)
                } else {
                    self.friendVM.isPending(receiverId: self.id) { isPending in
                        DispatchQueue.main.async {
                            if isPending {
                                self.addFriendButton.setTitle("Pending", for: .normal)
                                self.addFriendButton.backgroundColor = UIColor(hex: "c35ac7")
                            } else {
                                self.addFriendButton.setTitle("Add Friend", for: .normal)
                                self.addFriendButton.backgroundColor = UIColor(red: 0.16, green: 0.5, blue: 0.73, alpha: 1.0)
                            }
                            self.setupButton()
                        }
                    }
                }
            }
        }
    }
    
    func setupButton() {
        print(addFriendButton.currentTitle ?? "none title available")
        addFriendButton.removeTarget(self, action: nil, for: .allEvents)
        
        if addFriendButton.currentTitle == "Friend" {
            addFriendButton.addTarget(self, action: #selector(didTapUnfriend), for: .touchUpInside)
        } else if addFriendButton.currentTitle == "Pending" {
            addFriendButton.addTarget(self, action: #selector(didTapUnRequest), for: .touchUpInside)
        } else if addFriendButton.currentTitle == "Add Friend" {
            addFriendButton.addTarget(self, action: #selector(didTapAddFriend), for: .touchUpInside)
        }
    }
    
    @objc private func didTapUnfriend() {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to unfriend this user?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Unfriend", style: .destructive, handler: { _ in
            print("unfriend")
            self.accountVM.removeFromFriendList(id: self.id) { success in
                if success {
                    print("removed")
                    DispatchQueue.main.async {
                        self.viewWillAppear(true)
                    }
                } else {
                    print("can't remove")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapUnRequest() {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to cancel the friend request?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel Request", style: .destructive, handler: { _ in
            print("unrequest")
            self.accountVM.removeRequestOnUsers(id: self.id) { success in
                if success {
                    print("Request removed successfully")
                    DispatchQueue.main.async {
                        self.viewWillAppear(true)
                    }
                } else {
                    print("Failed to remove request")
                }
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func didTapAddFriend() {
        let alert = UIAlertController(title: "Confirm", message: "Are you sure you want to send a friend request?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Send Request", style: .default, handler: { _ in
            print("addfriend")
            self.friendVM.sendFriendRequest(receiverId: self.id)
            DispatchQueue.main.async {
                self.viewWillAppear(true)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc private func navButtonTapped(_ sender: UIButton) {
        [glimpseBtn, friendsBtn].forEach { $0.setTitleColor(.gray, for: .normal) }
        sender.setTitleColor(.black, for: .normal)
        
        if sender.tag == 0 {
            friendsListVw.isHidden = true
            glimpseView.isHidden = false
            noResultLbl.isHidden = true
            if accountVM.glimpse.count == 0{
                noGlimpseLbl.isHidden = false
            }
        } else {
            noGlimpseLbl.isHidden = true
            friendsListVw.isHidden = false
            glimpseView.isHidden = true
            
            if user?.friends?.count == 0 {
                noResultLbl.isHidden = false
            }
        }
        
        UIView.animate(withDuration: 0.3) {
            self.selectionIndicator.frame.origin.x = sender.frame.origin.x
        }
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
        
        UserDefaults.standard.removeObject(forKey: "authToken")
        
        NotificationCenter.default.post(name: .didLogout, object: nil)
        
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        
        let logoutSuccessAlert = UIAlertController(title: "", message: "Log out successfully", preferredStyle: .alert)
        self.present(logoutSuccessAlert, animated: true, completion: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = navController
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            logoutSuccessAlert.dismiss(animated: true)
        }
    }
    
    
}


extension OrtherAccountViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendVM.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsListCell", for: indexPath) as! FriendCell
        let friend = friendVM.friends[indexPath.row]
        if let username = friend["username"] as? String,
           let email = friend["email"] as? String,
           let image = friend["image"] as? String {
            cell.configure(image: image, username: username, email: email)
            cell.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            
        } else {
            print("Missing or invalid data for username, email, or image")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let friend = self.friendVM.friends[indexPath.row]
        let id = friend["_id"]
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}

extension OrtherAccountViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = accountVM.ortherGlimpse.count
        print("Number of items in collection view: \(count)")
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlimpseCell", for: indexPath) as! GlimpseCell
        let glimpse = accountVM.ortherGlimpse[indexPath.item]
        print("Configuring cell at index \(indexPath.item) with image URL: \(glimpse.image)")
        cell.configure(with: glimpse.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let padding: CGFloat = 10
        let totalPadding = (2 * padding) + ((numberOfItemsPerRow - 1) * padding)
        let width = (collectionView.frame.width - totalPadding) / numberOfItemsPerRow
        let size = CGSize(width: width, height: width)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let glimpse = accountVM.ortherGlimpse[indexPath.item]
        showImageView(for: glimpse)
    }

    
    private func showImageView(for glimpse: Glimpse) {
        dimmedView?.alpha = 1
        
        let imageViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        imageViewContainer.center = view.center
        imageViewContainer.backgroundColor = .white
        imageViewContainer.layer.cornerRadius = 10
        imageViewContainer.clipsToBounds = true
        
        let imageView = UIImageView(frame: imageViewContainer.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.downloaded(from: glimpse.image)
        imageViewContainer.addSubview(imageView)
        
        // Thêm một lớp overlay để đảm bảo hình ảnh không bị lộ ra ngoài
        let overlayView = UIView(frame: imageViewContainer.bounds)
        overlayView.backgroundColor = .black
        overlayView.layer.cornerRadius = 10
        overlayView.layer.masksToBounds = true
        imageViewContainer.addSubview(overlayView)
        imageViewContainer.sendSubviewToBack(overlayView)
        
        // Điều chỉnh nút "Show Location"
        let buttonWidth: CGFloat = 150
        let buttonHeight: CGFloat = 40
        let showLocationButton = UIButton(frame: CGRect(
            x: (imageViewContainer.bounds.width - buttonWidth) / 2,
            y: imageViewContainer.bounds.height - buttonHeight - 20,
            width: buttonWidth,
            height: buttonHeight
        ))
        showLocationButton.setTitle("Show Location", for: .normal)
        showLocationButton.backgroundColor = .black
        showLocationButton.setTitleColor(.white, for: .normal)
        showLocationButton.layer.cornerRadius = 10
        showLocationButton.addTarget(self, action: #selector(showLocation(_:)), for: .touchUpInside)
        imageViewContainer.addSubview(showLocationButton)
        
        showLocationButton.tag = glimpse.id.hashValue
        
        let closeButton = UIButton(frame: CGRect(x: imageViewContainer.bounds.width - 40, y: 0, width: 44, height: 44))
        closeButton.setImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
        closeButton.backgroundColor = .black
        closeButton.addTarget(self, action: #selector(closeImageView), for: .touchUpInside)
        imageViewContainer.addSubview(closeButton)
        
        self.view.addSubview(imageViewContainer)
        self.imageViewContainer = imageViewContainer
        
        imageViewContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3) {
            imageViewContainer.transform = .identity
        }
    }
    
    
    @objc private func showLocation(_ sender: UIButton) {
        let glimpse = accountVM.ortherGlimpse.first { $0.id.hashValue == sender.tag }
        guard let glimpse = glimpse else { return }
        showMapView(for: glimpse)
    }
    
    @objc private func closeImageView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.imageViewContainer?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { _ in
            self.imageViewContainer?.removeFromSuperview()
            self.imageViewContainer = nil
            self.dimmedView?.alpha = 0
        })
    }
    
    private func showMapView(for glimpse: Glimpse) {
        // Tạo UIView cho bản đồ
        let mapViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 350, height: 350))
        mapViewContainer.center = view.center
        mapViewContainer.backgroundColor = .white
        mapViewContainer.layer.cornerRadius = 10
        mapViewContainer.clipsToBounds = true
        
        let mapView = MKMapView(frame: mapViewContainer.bounds)
        mapViewContainer.addSubview(mapView)
        
        let coordinate = CLLocationCoordinate2D(latitude: glimpse.location.latitude, longitude: glimpse.location.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Glimpse Location"
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // Tạo nút đóng
        let closeButton = UIButton(frame: CGRect(x: mapViewContainer.bounds.width - 40, y: 0, width: 44, height: 44))
        closeButton.setImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeMapView), for: .touchUpInside)
        mapViewContainer.addSubview(closeButton)
        
        self.view.addSubview(mapViewContainer)
        self.mapViewContainer = mapViewContainer
        
        // Animate mapViewContainer
        mapViewContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.5) {
            mapViewContainer.transform = .identity
        }
    }
    
    @objc private func closeMapView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.mapViewContainer?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { _ in
            self.mapViewContainer?.removeFromSuperview()
            self.mapViewContainer = nil
            self.dimmedView?.alpha = 0
        })
    }
    
}

