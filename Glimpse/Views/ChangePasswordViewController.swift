//
//  ChangePasswordViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 20/09/2024.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    
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
        label.text = "Change Password"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currentPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Current Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "New Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm New Password"
        textField.isSecureTextEntry = true
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let changePasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Password", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(currentPasswordTextField)
        contentView.addSubview(newPasswordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(changePasswordButton)
        
        changePasswordButton.addTarget(self, action: #selector(changePasswordTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            contentView.heightAnchor.constraint(equalToConstant: 400),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            currentPasswordTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            currentPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            currentPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            currentPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordTextField.topAnchor.constraint(equalTo: currentPasswordTextField.bottomAnchor, constant: 20),
            newPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            newPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            changePasswordButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            changePasswordButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            changePasswordButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            changePasswordButton.heightAnchor.constraint(equalToConstant: 50),
            changePasswordButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func changePasswordTapped() {
        guard let currentPassword = self.currentPasswordTextField.text, !currentPassword.isEmpty,
              let newPassword = self.newPasswordTextField.text, !newPassword.isEmpty,
              let confirmPassword = self.confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            self.showAlert(message: "Please fill in all fields.")
            return
        }
        
        guard newPassword == confirmPassword else {
            self.showAlert(message: "New password and confirm password do not match.")
            return
        }
        
        self.changePassword(oldPass: currentPassword, newPass: newPassword) { flat in
            DispatchQueue.main.async {
                if flat == 0 {
                    self.showAlert(message: "Current password is incorrect")
                } else if flat == 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.showAlert(message: "Password changed successfully")
                    }
                    DispatchQueue.main.async {
                        let vc = AccountViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func changePassword(oldPass: String, newPass: String, completion: @escaping (Int) -> Void){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else{
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/changePassword") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "oldPassword": oldPass,
            "newPassword": newPass
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
            
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 400{
                completion(0)
                return
            }
            
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200{
                completion(1)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data){
                print(json)
            }
        }
        task.resume()
    }
}
