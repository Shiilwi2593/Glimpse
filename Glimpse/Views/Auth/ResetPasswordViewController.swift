//
//  ResetPasswordViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 20/09/2024.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    let signupVM = SignUpViewModel()
    var otp: String = ""
    private var otpView: OTPView?
    
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
        label.text = "Reset Password"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your email"
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let newPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter new password"
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        return textField
    }()
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm new password"
        textField.borderStyle = .none
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isHidden = true
        return textField
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send OTP", for: .normal)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(newPasswordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            emailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            
            newPasswordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            newPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            newPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            newPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordTextField.bottomAnchor, constant: 20),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            actionButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 30),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func actionButtonTapped() {
        if actionButton.titleLabel?.text == "Send OTP" {
            
            sendOTP()
        } else {
            confirmNewPassword()
        }
    }
    
    private func sendOTP() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        })
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Email must not be empty")
            return
        }
        
        signupVM.checkEmailAvailability(email: email) { exist, message in
            DispatchQueue.main.async {
                if exist{
                    self.signupVM.sendOTP(to: email) { success, message, otp in
                        if success {
                            self.otp = otp!
                            self.showOTPSheet()
                        } else {
                            self.showAlert(message: message ?? "Failed to send OTP")
                        }
                    }
                }else{
                    self.showAlert(message: "This email is not associated with any account")
                }
            }
            
            
        }
        
        
    }
    
    private func confirmNewPassword() {
        guard let newPassword = newPasswordTextField.text,
              let confirmPassword = confirmPasswordTextField.text,
              !newPassword.isEmpty, !confirmPassword.isEmpty else {
            showAlert(message: "Please enter and confirm your new password")
            return
        }
        
        guard newPassword == confirmPassword else {
            showAlert(message: "Passwords do not match")
            return
        }
        
        showAlert(message: "Password successfully updated")
    }
    
    private func showOTPSheet() {
        otpView = OTPView()
        otpView?.modalPresentationStyle = .popover
        
        otpView?.verifyOTPCompletion = { [weak self] userOtp in
            guard let self = self else { return }
            if userOtp == self.otp {
                self.showNewPasswordFields()
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
    
    private var dimmingView: UIView?
    
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
    
    private func showNewPasswordFields() {
        UIView.animate(withDuration: 0.3) {
            self.newPasswordTextField.isHidden = false
            self.confirmPasswordTextField.isHidden = false
            self.actionButton.setTitle("Confirm", for: .normal)
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
