//
//  SignUp2ViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 24/08/2024.
//

import UIKit

class SignUp2ViewController: UIViewController {
    
    let email: String
    let password: String
    let rePassword: String
    
    init(email: String, password: String, rePassword: String) {
        self.email = email
        self.password = password
        self.rePassword = rePassword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: -UI
//    private let 
    
    
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print(email, password, rePassword)
        setUp()
    }
    
    
    //MARK: -SetUp
    private func setUp(){
        
    }
}
