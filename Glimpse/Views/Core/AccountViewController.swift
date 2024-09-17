//
//  AccountViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 25/08/2024.
//

import UIKit
import Cloudinary

class AccountViewController: UIViewController, UINavigationControllerDelegate {
    
    var user: User?
    let mapVM = MapViewModel()
    let friendVM = FriendsViewModel()
    let accountVM = AccountViewModel()
    
    
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
        friendsListVw.register(FriendCell.self, forCellReuseIdentifier: "FriendsList")
        return friendsListVw
    }()
    
    private var editAvatarBtn: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "pencil.line")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.layer.borderWidth = 1
        button.contentMode = .scaleAspectFill
        button.backgroundColor = .systemGray6
        button.layer.masksToBounds = true
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
        title = "Profile"
        setUpNavigationBar()
        mapVM.getUserInfoByToken { user in
            self.user = user
            DispatchQueue.main.async {
                if let avatarUrlString = self.user?.image,
                   let avatarUrl = URL(string: avatarUrlString) {
                    self.avatarImg.downloaded(from: avatarUrl)
                }
                self.setUp()
            }
        }
        
        friendVM.fetchFriends()
        friendVM.onFriendsUpdated = {
            self.friendsListVw.reloadData()
            print("reload friend lists")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapVM.getUserInfoByToken { user in
            self.user = user
            DispatchQueue.main.async {
                if let username = self.user?.username {
                    self.usernameLbl.text = username
                }
                if let email = self.user?.email {
                    self.subtitleLbl.text = email
                }
                if let avatarUrlString = self.user?.image,
                   let avatarUrl = URL(string: avatarUrlString) {
                    self.avatarImg.downloaded(from: avatarUrl)
                }
            }
        }
        
        friendVM.fetchFriends()
        friendVM.onFriendsUpdated = {
            self.friendsListVw.reloadData()
            print("reload friend lists")
        }
    }
    
    override func viewDidLayoutSubviews() {
        editAvatarBtn.layer.cornerRadius = editAvatarBtn.frame.height / 2
        editAvatarBtn.clipsToBounds = true
        
    }
    
    //MARK: -SetUp
    private func setUp(){
        view.addSubview(avatarImg)
        view.addSubview(usernameLbl)
        view.addSubview(subtitleLbl)
        view.addSubview(statsStack)
        view.addSubview(navBar)
        view.addSubview(friendsListVw)
        view.addSubview(editAvatarBtn)
        
        navBar.addSubview(glimpseBtn)
        navBar.addSubview(friendsBtn)
        navBar.addSubview(selectionIndicator)
        
        
        self.avatarImg.downloaded(from: "https://i.ibb.co/jggwqDf/defaultavatar.jpg")
        
        
        if let username = self.user?.username{
            usernameLbl.text = username
        }
        
        if let email = self.user?.email{
            subtitleLbl.text = email
        }
        
        let glimpse = createStatView(value: "\(self.user?.friends?.count ?? 0)", label: "Friends")
        let friends = createStatView(value: "78", label: "Glimpse")
        let likes = createStatView(value: "99", label: "Likes")
        
        [friends, glimpse, likes].forEach { statsStack.addArrangedSubview($0) }
        
        friendsListVw.isHidden = true
        friendsListVw.dataSource = self
        friendsListVw.delegate = self
        
        NSLayoutConstraint.activate([
            avatarImg.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImg.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImg.widthAnchor.constraint(equalToConstant: 100),
            avatarImg.heightAnchor.constraint(equalToConstant: 100),
            
            editAvatarBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 32),
            editAvatarBtn.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: -22),
            editAvatarBtn.heightAnchor.constraint(equalToConstant: 35),
            editAvatarBtn.widthAnchor.constraint(equalToConstant: 35),
            
            usernameLbl.topAnchor.constraint(equalTo: avatarImg.bottomAnchor, constant: 16),
            usernameLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLbl.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 8),
            subtitleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            statsStack.topAnchor.constraint(equalTo: subtitleLbl.bottomAnchor, constant: 22),
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
            friendsListVw.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
        
        [glimpseBtn, friendsBtn].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        glimpseBtn.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        glimpseBtn.tag = 0
        friendsBtn.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        friendsBtn.tag = 1
        
        editAvatarBtn.addTarget(self, action: #selector(editAvatarTapped), for: .touchUpInside)
        
        //        addFriendButton.addTarget(self, action: #selector(addFriendTapped), for: .touchUpInside)
        
    }
    
    @objc private func editAvatarTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // Open gallery
        imagePickerController.allowsEditing = true // Optional: allows editing of the image
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func navButtonTapped(_ sender: UIButton) {
        [glimpseBtn, friendsBtn].forEach { $0.setTitleColor(.gray, for: .normal) }
        sender.setTitleColor(.black, for: .normal)
        
        if sender.tag == 0{
            friendsListVw.isHidden = true
            print("tag: 0")
        } else{
            friendsListVw.isHidden = false
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


extension AccountViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendVM.friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendsList", for: indexPath) as! FriendCell
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            uploadImage(image: selectedImage) { url in
                if let urlString = url {
                    self.accountVM.updateImage(url: urlString)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        picker.dismiss(animated: true, completion: nil)
                        self.viewWillAppear(true)
                    })

                }
            }
        }
 
    }


    
    func uploadImage(image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(nil)
            return
        }
        let cloudinary = CLDCloudinary(configuration: CLDConfiguration(cloudName: "dkea6b2lm", apiKey: "915397132791353", apiSecret: "IAE2SY2hl3UnmMMj28SdOkY8Ces"))

        cloudinary.createUploader().upload(data: imageData, uploadPreset: "ml_default", progress: { (progress) in
            print("Upload progress: \(progress.fractionCompleted)")
        }, completionHandler: { (result, error) in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let result = result, let url = result.secureUrl as String? else {
                completion(nil)
                return
            }
            print(url)

            completion(url)
        })
    }
    

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
