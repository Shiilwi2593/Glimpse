//
//  LoginViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 07/08/2024.
//

import UIKit

class LoginViewController: UIViewController {
    
    let loginVM = LoginViewModel()
    
    //MARK: -UI
    private let loginViewBackGround: UIImageView = {
        let loginViewBackGround = UIImageView()
        loginViewBackGround.translatesAutoresizingMaskIntoConstraints = false
        loginViewBackGround.image = UIImage(named: "loginPage")
        return loginViewBackGround
    }()
    
    private let loginContainer: UIView = {
        let loginContainer = UIView()
        loginContainer.translatesAutoresizingMaskIntoConstraints = false
        loginContainer.backgroundColor = .white
        loginContainer.layer.cornerRadius = 25
        return loginContainer
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
    
    private let forgotPassword: UILabel = {
        let forgotPassword = UILabel()
        forgotPassword.translatesAutoresizingMaskIntoConstraints = false
        forgotPassword.text = "Forgot password?"
        forgotPassword.font = UIFont.systemFont(ofSize: 14, weight: .light)
        forgotPassword.textColor = UIColor(hex: "A8A6A6")
        forgotPassword.isUserInteractionEnabled = true
        return forgotPassword
    }()
    
    private let passwordToggleBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let loginBtn: UIButton = {
        let loginBtn = UIButton()
        loginBtn.translatesAutoresizingMaskIntoConstraints = false
        loginBtn.setTitle("Sign In", for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        loginBtn.backgroundColor = UIColor(hex: "7E7ED7")
        loginBtn.layer.cornerRadius = 10
        return loginBtn
    }()
    
    private let signUpTxt: UILabel = {
        let signUpTxt = UILabel()
        signUpTxt.translatesAutoresizingMaskIntoConstraints = false
        signUpTxt.text = "Don’t have an account?"
        signUpTxt.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        signUpTxt.textColor = UIColor(hex: "A8A6A6")
        return signUpTxt
    }()
    
    private let signUpLbl: UILabel = {
        let signUpLbl = UILabel()
        signUpLbl.translatesAutoresizingMaskIntoConstraints = false
        signUpLbl.text = "Sign Up"
        signUpLbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        signUpLbl.textColor = UIColor(hex: "5299CC")
        return signUpLbl
    }()
    
    //MARK: -SetUp
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
        view.backgroundColor = UIColor(hex: "6ED2B2")
        view.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    //MARK: -SetUp
    private func SetUp(){
        view.addSubview(loginViewBackGround)
        view.addSubview(loginContainer)
        view.addSubview(emailLbl)
        view.addSubview(emailTxtField)
        view.addSubview(emailIconView)
        view.addSubview(passwordLbl)
        view.addSubview(passwordTxtField)
        view.addSubview(passwordIconView)
        view.addSubview(passwordToggleBtn)
        view.addSubview(forgotPassword)
        view.addSubview(loginBtn)
        view.addSubview(signUpTxt)
        view.addSubview(signUpLbl)
        
        passwordToggleBtn.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let tapGestureSignUp = UITapGestureRecognizer(target: self, action: #selector(didTapSignUpBtn))
        signUpLbl.isUserInteractionEnabled = true
        signUpLbl.addGestureRecognizer(tapGestureSignUp)
        
        loginBtn.addTarget(self, action: #selector(loginBtnTapped), for: .touchUpInside)
        
        
        let forgotPasswordTap = UITapGestureRecognizer(target: self, action: #selector(didTapForgotPassword))
         forgotPassword.addGestureRecognizer(forgotPasswordTap)
        
        NSLayoutConstraint.activate([
            loginViewBackGround.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 5),
            loginViewBackGround.topAnchor.constraint(equalTo: view.topAnchor),
            loginViewBackGround.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5),
            loginViewBackGround.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loginContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loginContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loginContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loginContainer.heightAnchor.constraint(equalToConstant: 530),
            
            emailLbl.leadingAnchor.constraint(equalTo: emailTxtField.leadingAnchor),
            emailLbl.topAnchor.constraint(equalTo: loginContainer.topAnchor, constant: 52),
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
            
            passwordToggleBtn.trailingAnchor.constraint(equalTo: passwordTxtField.trailingAnchor, constant: -16),
            passwordToggleBtn.centerYAnchor.constraint(equalTo: passwordTxtField.centerYAnchor),
            passwordToggleBtn.widthAnchor.constraint(equalToConstant: 20),
            passwordToggleBtn.heightAnchor.constraint(equalToConstant: 20),
            
            forgotPassword.topAnchor.constraint(equalTo: passwordTxtField.bottomAnchor, constant: 7),
            forgotPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            forgotPassword.heightAnchor.constraint(equalToConstant: 17),
            
            loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginBtn.topAnchor.constraint(equalTo: passwordIconView.bottomAnchor, constant: 65),
            loginBtn.heightAnchor.constraint(equalToConstant: 50),
            loginBtn.widthAnchor.constraint(equalToConstant: 336),
            
            signUpTxt.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -17),
            signUpTxt.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30),
            
            signUpLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -17),
            signUpLbl.leadingAnchor.constraint(equalTo: signUpTxt.trailingAnchor, constant: 4)
            
        ])
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardTopY = view.frame.height - keyboardFrame.height
        
        // Tính toán sự chồng chéo
        let emailTxtFieldBottomY = emailTxtField.frame.maxY
        let passwordTxtFieldBottomY = passwordTxtField.frame.maxY
        let loginContainerBottomY = loginContainer.frame.maxY
        
        let overlapEmailTxtField = emailTxtFieldBottomY - keyboardTopY
        let overlapPasswordTxtField = passwordTxtFieldBottomY - keyboardTopY
        let overlapLoginContainer = loginContainerBottomY - keyboardTopY
        
        // Chỉ di chuyển các phần tử bị chồng chéo với bàn phím
        if overlapEmailTxtField > 0 || overlapPasswordTxtField > 0 || overlapLoginContainer > 0 {
            UIView.animate(withDuration: 0.3) {
                let translationY: CGFloat
                if overlapLoginContainer > 0 {
                    translationY = -min(overlapLoginContainer + 20, 100) // Di chuyển tất cả các phần tử, giới hạn di chuyển ở 100 điểm
                } else if overlapPasswordTxtField > 0 {
                    translationY = -min(overlapPasswordTxtField + 20, 100) // Di chuyển các phần tử đến trên trường mật khẩu, giới hạn di chuyển ở 100 điểm
                } else {
                    translationY = -min(overlapEmailTxtField + 20, 100) // Di chuyển các phần tử đến trên trường email, giới hạn di chuyển ở 100 điểm
                }
                self.view.transform = CGAffineTransform(translationX: 0, y: translationY)
            }
        }
    }
    
    
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.transform = .identity
        }
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    
    
    @objc private func togglePasswordVisibility() {
        passwordTxtField.isSecureTextEntry.toggle()
        passwordToggleBtn.isSelected.toggle()
    }
    
    @objc private func didTapSignUpBtn(){
        let vc = SignUpViewController()
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        navigationItem.backButtonTitle = "Log in"
    }
    
    @objc private func didTapForgotPassword() {
        let resetPasswordVC = ResetPasswordViewController() // Assume you have this view controller
        resetPasswordVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    
   @objc private func loginBtnTapped(){
        print("Login button tapped")
        
        // Animate the login button to indicate it's been tapped
        UIView.animate(withDuration: 0.5, animations: {
            self.loginBtn.alpha = 0.5
        }, completion: { _ in
            UIView.animate(withDuration: 0.5) {
                self.loginBtn.alpha = 1.0
            }
        })
        
        // Ensure both email and password fields are filled
        guard let email = emailTxtField.text, !email.isEmpty,
              let password = passwordTxtField.text, !password.isEmpty else {
            let alert = UIAlertController(title: "", message: "All fields are required", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        
        self.loginVM.login(email: email, password: password) { success, token in
            DispatchQueue.main.async {
                if success {
                    let activityIndicator = UIActivityIndicatorView(style: .large)
                    activityIndicator.center = self.view.center
                    activityIndicator.startAnimating()
                    self.view.addSubview(activityIndicator)
                    
                    self.loginBtn.isEnabled = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        activityIndicator.stopAnimating()
                        activityIndicator.removeFromSuperview()
                        
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set(token, forKey: "authToken")
                        print("Token: \(token ?? "No token")")
                        
                        let vc = TabBarViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                        self.navigationItem.setHidesBackButton(true, animated: true)
                        self.navigationController?.navigationBar.isHidden = true

                    }
                } else {
                    let alert = UIAlertController(title: "", message: "Invalid email or password.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
