//
//  SignUpViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 12/08/2024.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    let signUpVM = SignUpViewModel()
    var otp: String = ""
    private var otpView: OTPView?
    
    
    
    //MARK: -UI
    private let backgroundImg: UIImageView = {
        let backgroundImg = UIImageView()
        backgroundImg.translatesAutoresizingMaskIntoConstraints = false
        backgroundImg.image = UIImage(named: "signUpPage")
        return backgroundImg
    }()
    
    private let signUpContainer: UIView = {
        let signUpContainer = UIView()
        signUpContainer.translatesAutoresizingMaskIntoConstraints = false
        signUpContainer.backgroundColor = .white
        signUpContainer.layer.cornerRadius = 25
        return signUpContainer
    }()
    
    private let usernameLbl: UILabel = {
        let usernameLbl = UILabel()
        usernameLbl.text = "Username"
        usernameLbl.translatesAutoresizingMaskIntoConstraints = false
        usernameLbl.textColor = .black
        usernameLbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return usernameLbl
    }()
    
    private let usernameIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill.questionmark")
        imageView.tintColor = .gray
        return imageView
    }()
    
    
    private let usernameTxtField: UITextField = {
        let usernameTxtField = UITextField()
        usernameTxtField.translatesAutoresizingMaskIntoConstraints = false
        usernameTxtField.placeholder = "Enter your username"
        usernameTxtField.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
        usernameTxtField.layer.borderWidth = 1
        usernameTxtField.layer.cornerRadius = 10
        usernameTxtField.leftView = UIView(frame: CGRect(x: 0 , y: 0, width: 45, height: 48))
        usernameTxtField.leftViewMode = .always
        usernameTxtField.autocapitalizationType = .none
        return usernameTxtField
    }()
    
    private let emailLbl: UILabel = {
        let emailLbl = UILabel()
        emailLbl.text = "Email"
        emailLbl.translatesAutoresizingMaskIntoConstraints = false
        emailLbl.textColor = .black
        emailLbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return emailLbl
    }()
    
    private let emailTxtField: UITextField = {
        let emailTxtField = UITextField()
        emailTxtField.translatesAutoresizingMaskIntoConstraints = false
        emailTxtField.placeholder = "Enter your email"
        emailTxtField.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
        emailTxtField.layer.borderWidth = 1
        emailTxtField.layer.cornerRadius = 10
        emailTxtField.leftView = UIView(frame: CGRect(x: 0 , y: 0, width: 45, height: 48))
        emailTxtField.leftViewMode = .always
        emailTxtField.autocapitalizationType = .none
        return emailTxtField
    }()
    
    private let emailIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "envelope")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let passwordLbl: UILabel = {
        let passwordLbl = UILabel()
        passwordLbl.text = "Password"
        passwordLbl.translatesAutoresizingMaskIntoConstraints = false
        passwordLbl.textColor = .black
        passwordLbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return passwordLbl
    }()
    
    private let passwordTxtField: UITextField = {
        let passwordTxtField = UITextField()
        passwordTxtField.translatesAutoresizingMaskIntoConstraints = false
        passwordTxtField.placeholder = "Enter your password"
        passwordTxtField.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
        passwordTxtField.layer.borderWidth = 1
        passwordTxtField.layer.cornerRadius = 10
        passwordTxtField.leftView = UIView(frame: CGRect(x: 0 , y: 0, width: 45, height: 48))
        passwordTxtField.leftViewMode = .always
        passwordTxtField.autocapitalizationType = .none
        passwordTxtField.isSecureTextEntry = true
        return passwordTxtField
    }()
    
    private let passwordIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let rePasswordLbl: UILabel = {
        let passwordLbl = UILabel()
        passwordLbl.text = "Confirm password"
        passwordLbl.translatesAutoresizingMaskIntoConstraints = false
        passwordLbl.textColor = .black
        passwordLbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return passwordLbl
    }()
    
    private let rePasswordTxtField: UITextField = {
        let passwordTxtField = UITextField()
        passwordTxtField.translatesAutoresizingMaskIntoConstraints = false
        passwordTxtField.placeholder = "Re-enter your password"
        passwordTxtField.layer.borderColor = UIColor(hex: "DDDDDD").cgColor
        passwordTxtField.layer.borderWidth = 1
        passwordTxtField.layer.cornerRadius = 10
        passwordTxtField.leftView = UIView(frame: CGRect(x: 0 , y: 0, width: 45, height: 48))
        passwordTxtField.leftViewMode = .always
        passwordTxtField.autocapitalizationType = .none
        passwordTxtField.isSecureTextEntry = true
        return passwordTxtField
    }()
    
    private let rePasswordIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.tintColor = .gray
        return imageView
    }()
    
    private let passwordToggleBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rePasswordToggleBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpBtn: UIButton = {
        let signUpBtn = UIButton()
        signUpBtn.translatesAutoresizingMaskIntoConstraints = false
        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        signUpBtn.backgroundColor = UIColor(hex: "68D0CC")
        signUpBtn.layer.cornerRadius = 10
        return signUpBtn
    }()
    
    
    
    //MARK: -LifeCylcle
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
        navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    //MARK: -SetUp
    private func SetUp(){
        view.addSubview(backgroundImg)
        view.addSubview(signUpContainer)
        view.addSubview(usernameLbl)
        view.addSubview(usernameIconView)
        view.addSubview(usernameTxtField)
        view.addSubview(emailLbl)
        view.addSubview(emailTxtField)
        view.addSubview(emailIconView)
        view.addSubview(passwordLbl)
        view.addSubview(passwordTxtField)
        view.addSubview(passwordIconView)
        view.addSubview(signUpBtn)
        view.addSubview(rePasswordLbl)
        view.addSubview(rePasswordIconView)
        view.addSubview(rePasswordTxtField)
        view.addSubview(passwordToggleBtn)
        view.addSubview(rePasswordToggleBtn)
        
        passwordTxtField.delegate = self
        rePasswordTxtField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        passwordToggleBtn.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        rePasswordToggleBtn.addTarget(self, action: #selector(toggleRePasswordVisibility), for: .touchUpInside)
        
        signUpBtn.addTarget(self, action: #selector(signUpBtnTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            backgroundImg.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImg.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImg.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImg.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            signUpContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            signUpContainer.heightAnchor.constraint(equalToConstant: 530),
            
            usernameLbl.leadingAnchor.constraint(equalTo: usernameTxtField.leadingAnchor, constant: 0),
            usernameLbl.topAnchor.constraint(equalTo: signUpContainer.topAnchor, constant: 20),
            
            usernameTxtField.topAnchor.constraint(equalTo: usernameLbl.bottomAnchor, constant: 16),
            usernameTxtField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameTxtField.heightAnchor.constraint(equalToConstant: 50),
            usernameTxtField.widthAnchor.constraint(equalToConstant: 330),
            
            usernameIconView.leadingAnchor.constraint(equalTo: usernameTxtField.leadingAnchor, constant: 16),
            usernameIconView.centerYAnchor.constraint(equalTo: usernameTxtField.centerYAnchor),
            usernameIconView.widthAnchor.constraint(equalToConstant: 20),
            usernameIconView.heightAnchor.constraint(equalToConstant: 20),
            
            
            emailLbl.leadingAnchor.constraint(equalTo: emailTxtField.leadingAnchor, constant: 0),
            emailLbl.topAnchor.constraint(equalTo: usernameTxtField.bottomAnchor, constant: 15),
            emailLbl.heightAnchor.constraint(equalToConstant: 15),
            
            emailTxtField.topAnchor.constraint(equalTo: emailLbl.bottomAnchor, constant: 16),
            emailTxtField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTxtField.widthAnchor.constraint(equalToConstant: 330),
            emailTxtField.heightAnchor.constraint(equalToConstant: 50),
            
            emailIconView.leadingAnchor.constraint(equalTo: emailTxtField.leadingAnchor, constant: 16),
            emailIconView.centerYAnchor.constraint(equalTo: emailTxtField.centerYAnchor),
            emailIconView.widthAnchor.constraint(equalToConstant: 20),
            emailIconView.heightAnchor.constraint(equalToConstant: 20),
            
            passwordLbl.leadingAnchor.constraint(equalTo: passwordTxtField.leadingAnchor),
            passwordLbl.topAnchor.constraint(equalTo: emailTxtField.bottomAnchor, constant: 15),
            passwordLbl.heightAnchor.constraint(equalToConstant: 15),
            
            passwordTxtField.topAnchor.constraint(equalTo: passwordLbl.bottomAnchor, constant: 16),
            passwordTxtField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTxtField.widthAnchor.constraint(equalToConstant: 330),
            passwordTxtField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordIconView.leadingAnchor.constraint(equalTo: passwordTxtField.leadingAnchor, constant: 16),
            passwordIconView.centerYAnchor.constraint(equalTo: passwordTxtField.centerYAnchor),
            passwordIconView.widthAnchor.constraint(equalToConstant: 20),
            passwordIconView.heightAnchor.constraint(equalToConstant: 20),
            
            rePasswordLbl.leadingAnchor.constraint(equalTo: rePasswordTxtField.leadingAnchor),
            rePasswordLbl.topAnchor.constraint(equalTo: passwordTxtField.bottomAnchor, constant: 15),
            rePasswordLbl.heightAnchor.constraint(equalToConstant: 15),
            
            rePasswordTxtField.topAnchor.constraint(equalTo: rePasswordLbl.bottomAnchor, constant: 16),
            rePasswordTxtField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rePasswordTxtField.widthAnchor.constraint(equalToConstant: 330),
            rePasswordTxtField.heightAnchor.constraint(equalToConstant: 50),
            
            rePasswordIconView.leadingAnchor.constraint(equalTo: rePasswordTxtField.leadingAnchor, constant: 16),
            rePasswordIconView.centerYAnchor.constraint(equalTo: rePasswordTxtField.centerYAnchor),
            rePasswordIconView.widthAnchor.constraint(equalToConstant: 20),
            rePasswordIconView.heightAnchor.constraint(equalToConstant: 20),
            
            passwordToggleBtn.trailingAnchor.constraint(equalTo: passwordTxtField.trailingAnchor, constant: -16),
            passwordToggleBtn.centerYAnchor.constraint(equalTo: passwordTxtField.centerYAnchor),
            passwordToggleBtn.widthAnchor.constraint(equalToConstant: 20),
            passwordToggleBtn.heightAnchor.constraint(equalToConstant: 20),
            
            // Constraints for rePasswordToggleBtn
            rePasswordToggleBtn.trailingAnchor.constraint(equalTo: rePasswordTxtField.trailingAnchor, constant: -16),
            rePasswordToggleBtn.centerYAnchor.constraint(equalTo: rePasswordTxtField.centerYAnchor),
            rePasswordToggleBtn.widthAnchor.constraint(equalToConstant: 20),
            rePasswordToggleBtn.heightAnchor.constraint(equalToConstant: 20),
            
            
            signUpBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpBtn.topAnchor.constraint(equalTo: rePasswordTxtField.bottomAnchor, constant: 28),
            signUpBtn.heightAnchor.constraint(equalToConstant: 50),
            signUpBtn.widthAnchor.constraint(equalToConstant: 330),
        ])
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let activeTextField = [passwordTxtField, rePasswordTxtField].first(where: { $0.isFirstResponder })
        
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                let difference = bottomOfTextField - topOfKeyboard
                self.view.frame.origin.y = -difference - 10
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    @objc private func signUpBtnTapped() {
        guard let username = usernameTxtField.text, !username.isEmpty,
              let email = emailTxtField.text, !email.isEmpty,
              let password = passwordTxtField.text, !password.isEmpty,
              let rePassword = rePasswordTxtField.text, !rePassword.isEmpty else {
            showAlert(message: "All fields are required")
            return
        }
        
        guard password == rePassword else {
            showAlert(message: "Passwords do not match")
            return
        }
        
        guard password.count > 8 else {
            showAlert(message: "Password must contain more than 8 characters")
            return
        }
        
        guard username.count > 6 else {
            showAlert(message: "Username must contain more than 6 characters")
            return
        }
        
        signUpVM.checkUsernameAvailability(username: username) { [weak self] exists, message in
            if exists {
                DispatchQueue.main.async {
                    self?.showAlert(message: message ?? "Username already exists")
                }
            } else {
                self?.signUpVM.checkEmailAvailability(email: email) { exists, message in
                    if exists {
                        DispatchQueue.main.async {
                            self?.showAlert(message: message ?? "Email already exists")
                        }
                    } else {
                        // Send OTP and show OTP sheet
                        self?.signUpVM.sendOTP(to: email) { success, message, otp  in
                            DispatchQueue.main.async {
                                if success {
                                    self?.otp = otp!
                                    self?.showOTPSheet()
                                    
                                } else {
                                    self?.showAlert(message: message ?? "Failed to send OTP")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var dimmingView: UIView?
    
    private func showOTPSheet() {
        otpView = OTPView()
        otpView?.modalPresentationStyle = .popover
        
        otpView?.verifyOTPCompletion = { [weak self] userOtp in
            guard let self = self else { return }
            if userOtp == self.otp {
                self.proceedWithSignUp()
            } else {
                self.showAlert(message: "Wrong OTP")
            }
            self.hideOTPView()
        }
        
        if let otpView = otpView {
            let dimmingView = UIView(frame: view.bounds)
            dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            dimmingView.alpha = 0
            self.dimmingView = dimmingView
            view.addSubview(dimmingView)
            
            addChild(otpView)
            view.addSubview(otpView.view)
            
            otpView.view.frame = CGRect(x: (view.bounds.width - 380) / 2, y: (view.bounds.height - 200) / 2, width: 380, height: 220)
            
            otpView.view.alpha = 0
            otpView.view.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            
            UIView.animate(withDuration: 0.3) {
                dimmingView.alpha = 1
                otpView.view.alpha = 1
                otpView.view.transform = .identity
            } completion: { _ in
                otpView.didMove(toParent: self)
            }
            
        }
    }
    
    private func hideOTPView() {
        guard let otpView = otpView else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.dimmingView?.alpha = 0
            otpView.view.alpha = 0
            otpView.view.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { [weak self] _ in
            otpView.willMove(toParent: nil)
            otpView.view.removeFromSuperview()
            otpView.removeFromParent()
            
            self?.dimmingView?.removeFromSuperview()
            self?.otpView = nil
            self?.dimmingView = nil
        }
    }
    
    
    private func proceedWithSignUp() {
        guard let username = usernameTxtField.text,
              let email = emailTxtField.text,
              let password = passwordTxtField.text else { return }
        
        signUpVM.signUp(username: username, email: email, password: password) { [weak self] success, message in
            DispatchQueue.main.async {
                if success {
                    self?.showAlertSuccess(message: "Registration successful",color: UIColor(hex: "097a2b")) {
                        DispatchQueue.main.async {
                            let vc = LoginViewController()
                            self?.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                } else {
                    self?.showAlertSuccess(message: "Registration failed",color: UIColor(hex: "7d0b0b"))                }
            }
        }
    }
    
    
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alertController, animated: true, completion: nil)
    }
    
    private func showAlertSuccess(message: String,color: UIColor, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.setMessage(font: UIFont.systemFont(ofSize: 16), color: color)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func togglePasswordVisibility() {
        passwordTxtField.isSecureTextEntry.toggle()
        passwordToggleBtn.isSelected.toggle()
    }
    
    @objc private func toggleRePasswordVisibility() {
        rePasswordTxtField.isSecureTextEntry.toggle()
        rePasswordToggleBtn.isSelected.toggle()
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
}
