//
//  ChangeUsernameViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 20/09/2024.
//

import UIKit

class ChangeUsernameViewController: UIViewController {

    let signUpVM = SignUpViewModel()
    
    //MARK: -UI
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Username"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter new username"
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let changeUsernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Username", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupViews()
        // Thêm tap gesture để ẩn bàn phím
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(usernameTextField)
        contentView.addSubview(changeUsernameButton)
        
        changeUsernameButton.addTarget(self, action: #selector(changeUsernameTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            usernameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            changeUsernameButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 30),
            changeUsernameButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            changeUsernameButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            changeUsernameButton.heightAnchor.constraint(equalToConstant: 50),
            changeUsernameButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    //MARK: -Function
    @objc private func changeUsernameTapped() {
        guard let newUsername = usernameTextField.text, !newUsername.isEmpty else {
            showAlert(message: "Username cannot be empty.")
            return
        }
        DispatchQueue.main.async {
            self.changeUsername()
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func changeUsername() {
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(message: "Username must not be blank")
            return
        }
        
        guard username.count >= 8 && username.count <= 16 else {
            showAlert(message: "Username must contain 8 to 16 characters.")
            return
        }
        
        signUpVM.checkUsernameAvailability(username: username) { exists, _ in
            DispatchQueue.main.async {
                if exists {
                    self.showAlert(message: "This username is already in use")
                } else {
                    self.changeUsername(newUsername: username) { success in
                        if success {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.showAlert(message: "Username changed successfully")
                            }
                            
                            DispatchQueue.main.async {
                                let vc = AccountViewController()
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                       
                        } else {
                            self.showAlert(message: "Failed to change username.")
                        }
                    }
                }
            }
        }
    }

    
    func changeUsername(newUsername: String, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "lo/api/users/changeUsername") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "newUsername": newUsername
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                let isExist = json["success"] as! Bool
                completion(isExist)

            }
            
        }
        task.resume()
        
    }
    
    
}
