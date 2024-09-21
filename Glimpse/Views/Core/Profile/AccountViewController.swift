//
//  AccountViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 25/08/2024.
//

import UIKit
import Cloudinary
import MapKit

class AccountViewController: UIViewController, UINavigationControllerDelegate {
    
    var user: User?
    let mapVM = MapViewModel()
    let friendVM = FriendsViewModel()
    let accountVM = AccountViewModel()
    private var mapViewContainer: UIView?
    private var dimmedView: UIView?
    private var imageViewContainer: UIView?
    
    
    //MARK: -UI
    private let avatarImg: UIImageView = {
        let avatarImg = UIImageView()
        avatarImg.translatesAutoresizingMaskIntoConstraints = false
        avatarImg.contentMode = .scaleToFill
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
    
    
    private let noFrLbl: UILabel = {
        let noResultLbl = UILabel()
        noResultLbl.translatesAutoresizingMaskIntoConstraints = false
        noResultLbl.text = "This account has no friends"
        noResultLbl.textColor = .gray
        noResultLbl.isHidden = true
        noResultLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return noResultLbl
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
        self.viewWillAppear(true)
        
        
        glimpseView.isHidden = false
        friendsListVw.isHidden = true
        
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
                
                self.glimpseView.isHidden = false
                self.friendsListVw.isHidden = true
                
                self.fetchGlimpses {
                    self.createStatsViews()
                }
                
                self.friendVM.fetchFriends()
                self.friendVM.onFriendsUpdated = {
                    self.friendsListVw.reloadData()
                    print("reload friend lists")
                }
                
                self.statsStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
            }
        }
        tabBarController?.tabBar.isHidden = false
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    func createStatsViews() {
        let glimpse = self.createStatView(value: "\(self.user?.friends?.count ?? 0)", label: "Friends")
        let friends = self.createStatView(value: "\(self.accountVM.glimpse.count)", label: "Glimpse")
        
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
        
        accountVM.getUserGlimpse { [weak self] in
            DispatchQueue.main.async {
                completion()
                self?.glimpseView.reloadData()
                print("Reloaded glimpse view data")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    loading.stopAnimating()
                    loading.removeFromSuperview()
                }
                if self?.accountVM.glimpse.count == 0{
                    self?.noGlimpseLbl.isHidden = false
                }
            }
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
        view.addSubview(glimpseView)
        view.addSubview(noGlimpseLbl)
        view.addSubview(noFrLbl)
        
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
        
        dimmedView = UIView(frame: view.bounds)
        dimmedView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        dimmedView?.alpha = 0
        view.addSubview(dimmedView!)
        
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
            statsStack.heightAnchor.constraint(equalToConstant: 50),
            
            
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
            
            noGlimpseLbl.centerXAnchor.constraint(equalTo: glimpseView.centerXAnchor),
            noGlimpseLbl.centerYAnchor.constraint(equalTo: glimpseView.centerYAnchor),
            
            noFrLbl.centerXAnchor.constraint(equalTo: friendsListVw.centerXAnchor),
            noFrLbl.centerYAnchor.constraint(equalTo: friendsListVw.centerYAnchor)
            
        ])
        
        [glimpseBtn, friendsBtn].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        glimpseBtn.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        glimpseBtn.tag = 0
        friendsBtn.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
        friendsBtn.tag = 1
        
        editAvatarBtn.addTarget(self, action: #selector(editAvatarTapped), for: .touchUpInside)
        
        
    }
    
    @objc private func editAvatarTapped() {
        UIView.animate(withDuration: 0.5, animations: {
            self.editAvatarBtn.alpha = 0.5
        }) { _ in
            let loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.center = self.view.center
            self.view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
                
                UIView.animate(withDuration: 0.5) {
                    self.editAvatarBtn.alpha = 1.0
                }
                
                
            }
        }
    }
    
    
    @objc private func navButtonTapped(_ sender: UIButton) {
        [glimpseBtn, friendsBtn].forEach { $0.setTitleColor(.gray, for: .normal) }
        sender.setTitleColor(.black, for: .normal)
        
        if sender.tag == 0 {
            friendsListVw.isHidden = true
            glimpseView.isHidden = false
            noFrLbl.isHidden = true
            if accountVM.glimpse.count == 0{
                view.addSubview(noGlimpseLbl)
                noGlimpseLbl.isHidden = false
            }
        } else {
            friendsListVw.isHidden = false
            glimpseView.isHidden = true
            noGlimpseLbl.isHidden = true
            
            if user?.friends?.count == 0 {
                view.addSubview(noFrLbl)
                noFrLbl.isHidden = false
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
        let changeUsername = UIAction(title: "Change username", image: UIImage(systemName: "pencil")) { _ in
            self.editButtonTapped()
        }
        
        let changePassword = UIAction(title: "Change password", image: UIImage(systemName: "key")){_ in
            self.changePasswordBtnTapped()
        }
        
        let logoutAction = UIAction(title: "Logout", image: UIImage(systemName: "arrow.right.square")) { _ in
            self.logoutButtonTapped()
        }
        
        return UIMenu(title: "", options: .displayInline, children: [changeUsername, changePassword, logoutAction])
    }
    
    //MARK: - Actions
    @objc private func editButtonTapped() {
        let vc = ChangeUsernameViewController()
        navigationController?.pushViewController(vc, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func changePasswordBtnTapped(){
        let vc = ChangePasswordViewController()
        navigationController?.pushViewController(vc, animated: true)
        tabBarController?.tabBar.isHidden = true
    }
    
    @objc private func logoutButtonTapped() {
        print("Logout button tapped")
        
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "isLoggedIn")
        
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
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = picker.view.center
            picker.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            
            uploadImage(image: selectedImage) { url in
                DispatchQueue.main.async {
                    activityIndicator.stopAnimating()
                    activityIndicator.removeFromSuperview()
                    
                    if let urlString = url {
                        self.accountVM.updateImage(url: urlString)
                    }
                    
                    picker.dismiss(animated: true, completion: nil)
                    self.viewWillAppear(true)
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

extension AccountViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountVM.glimpse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GlimpseCell", for: indexPath) as! GlimpseCell
        let glimpse = accountVM.glimpse[indexPath.item]
        cell.configure(with: glimpse.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let padding: CGFloat = 10
        let totalPadding = (2 * padding) + ((numberOfItemsPerRow - 1) * padding)
        let width = (collectionView.frame.width - totalPadding) / numberOfItemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let glimpse = accountVM.glimpse[indexPath.item]
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
        
        let overlayView = UIView(frame: imageViewContainer.bounds)
        overlayView.backgroundColor = .black
        overlayView.layer.cornerRadius = 10
        overlayView.layer.masksToBounds = true
        imageViewContainer.addSubview(overlayView)
        imageViewContainer.sendSubviewToBack(overlayView)
        
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
        
        let deleteButtonSize: CGFloat = 50
        let deleteButton = UIButton(frame: CGRect(
            x: 10,
            y: imageViewContainer.bounds.height - deleteButtonSize - 10,
            width: deleteButtonSize,
            height: deleteButtonSize
        ))
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark.bin.circle.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: deleteButtonSize * 0.6, weight: .bold)
        config.background.backgroundColor = .black
        deleteButton.configuration = config
        
        deleteButton.tintColor = .white
        deleteButton.layer.cornerRadius = deleteButtonSize / 2
        deleteButton.clipsToBounds = true
        deleteButton.addTarget(self, action: #selector(deleteGlimpse(_:)), for: .touchUpInside)
        deleteButton.accessibilityIdentifier = glimpse.id
        imageViewContainer.addSubview(deleteButton)
        
        self.view.addSubview(imageViewContainer)
        self.imageViewContainer = imageViewContainer
        
        imageViewContainer.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 0.3) {
            imageViewContainer.transform = .identity
        }
    }
    
    @objc private func deleteGlimpse(_ sender: UIButton) {
        guard let glimpseId = sender.accessibilityIdentifier,
              let glimpse = accountVM.glimpse.first(where: { $0.id == glimpseId }) else {
            print("Glimpse not found")
            return
        }
        
        accountVM.deleteUserGlimpse(glimpseId: glimpse.id) { [weak self] success in
            DispatchQueue.main.async {
                if success {
                    self?.showAlert(message: "Deleted successfully")
                    self?.closeImageView()
                    self?.viewWillAppear(true)
                } else {
                    self?.showAlert(message: "Failed to delete")
                }
            }
        }
    }
    
    @objc private func showLocation(_ sender: UIButton) {
        let glimpse = accountVM.glimpse.first { $0.id.hashValue == sender.tag }
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
        
        let closeButton = UIButton(frame: CGRect(x: mapViewContainer.bounds.width - 40, y: 0, width: 44, height: 44))
        closeButton.setImage(UIImage(systemName: "xmark.square.fill"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeMapView), for: .touchUpInside)
        mapViewContainer.addSubview(closeButton)
        
        self.view.addSubview(mapViewContainer)
        self.mapViewContainer = mapViewContainer
        
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}


