//
//  OTPSheetViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 27/08/2024.
//

import UIKit

class OTPView: UIViewController {
    private let otpFields: [UITextField] = {
        var fields = [UITextField]()
        for _ in 1...6 {
            let field = UITextField()
            field.placeholder = "-"
            field.borderStyle = .none
            field.keyboardType = .numberPad
            field.textAlignment = .center
            field.font = .systemFont(ofSize: 24)
            field.translatesAutoresizingMaskIntoConstraints = false
            field.backgroundColor = .white
            field.layer.cornerRadius = 10
            field.layer.borderWidth = 1
            field.layer.borderColor = UIColor.systemGray4.cgColor
            fields.append(field)
        }
        return fields
    }()
    
    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please check your email for the OTP"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.text = "10:00"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemPink
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let verifyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Verify OTP", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var verifyOTPCompletion: ((String) -> Void)?
    private var timer: Timer?
    private var remainingTime: TimeInterval = 10 * 60 // 10 minutes
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startTimer()
        for field in otpFields {
            field.delegate = self
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.systemGray4.cgColor

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)

        containerView.addSubview(instructionLabel)
        containerView.addSubview(countdownLabel)
        containerView.addSubview(verifyButton)
        
        // Layout constraints for instructionLabel
        instructionLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        instructionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        instructionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true

        // Layout constraints for countdownLabel
        countdownLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 10).isActive = true
        countdownLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        
        // Layout constraints for OTP fields
        for (index, field) in otpFields.enumerated() {
            containerView.addSubview(field)
            field.heightAnchor.constraint(equalToConstant: 44).isActive = true
            field.topAnchor.constraint(equalTo: countdownLabel.bottomAnchor, constant: 20).isActive = true
            
            if index == 0 {
                field.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
            } else {
                field.leadingAnchor.constraint(equalTo: otpFields[index - 1].trailingAnchor, constant: 10).isActive = true
            }
            if index == otpFields.count - 1 {
                field.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
            }
        }
        
        otpFields.first?.widthAnchor.constraint(equalTo: otpFields.last!.widthAnchor).isActive = true
        for i in 1..<otpFields.count {
            otpFields[i].widthAnchor.constraint(equalTo: otpFields[i-1].widthAnchor).isActive = true
        }
        
        // Layout constraints for verifyButton
        verifyButton.topAnchor.constraint(equalTo: otpFields.last!.bottomAnchor, constant: 20).isActive = true
        verifyButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20).isActive = true
        verifyButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        // Container view constraints
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalToConstant: 380).isActive = true
        containerView.bottomAnchor.constraint(equalTo: verifyButton.bottomAnchor, constant: 20).isActive = true

        verifyButton.addTarget(self, action: #selector(verifyButtonTapped), for: .touchUpInside)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }
    
    @objc private func updateCountdown() {
        if remainingTime > 0 {
            remainingTime -= 1
            let minutes = Int(remainingTime) / 60
            let seconds = Int(remainingTime) % 60
            countdownLabel.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            timer?.invalidate()
            timer = nil
            showAlert(message: "Time's up! Please sign up again.")
            disableOTPFields()
        }
    }
    
    private func disableOTPFields() {
        for field in otpFields {
            field.isEnabled = false
        }
        verifyButton.isEnabled = false
    }
    
    @objc private func verifyButtonTapped() {
        var otp = ""
        for field in otpFields {
            if let text = field.text, !text.isEmpty {
                otp += text
            } else {
                // Show an alert if OTP is empty
                let alert = UIAlertController(title: "Error", message: "Please enter OTP", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
        }
        verifyOTPCompletion?(otp)
        dismiss(animated: true, completion: nil)
    }
    
    func updateInstructionLabel(with email: String) {
        instructionLabel.text = "Please check \(email) for the OTP"
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension OTPView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }
        if let text = textField.text, text.count >= 1 {
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let text = textField.text, text.count == 1 {
            for (index, field) in otpFields.enumerated() {
                if field == textField {
                    if index < otpFields.count - 1 {
                        otpFields[index + 1].becomeFirstResponder()
                    }
                    break
                }
            }
        } else if textField.text?.isEmpty ?? true {
            for (index, field) in otpFields.enumerated() {
                if field == textField {
                    if index > 0 {
                        otpFields[index - 1].becomeFirstResponder()
                    }
                    break
                }
            }
        }
    }
}
