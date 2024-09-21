//
//  ViewController.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 07/08/2024.
//

import UIKit

class StartViewController: UIViewController {
    
    //MARK: -UI
    private let startPage: UIImageView = {
        let startPage = UIImageView()
        startPage.translatesAutoresizingMaskIntoConstraints = false
        startPage.image = UIImage(named: "startPage")
        return startPage
    }()
    
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        SetUp()
    }
    
    
    
    //MARK: SetUp
    private func SetUp(){
        view.addSubview(startPage)
        
        NSLayoutConstraint.activate([
            startPage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            startPage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            startPage.topAnchor.constraint(equalTo: view.topAnchor,constant: 20),
            startPage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    
}

