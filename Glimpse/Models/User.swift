//
//  User.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 24/08/2024.
//

import Foundation

struct User: Decodable {
    let _id: String
    let username: String?
    let email: String
    let image: String?
    let friends: [String]?
    let location: Location
    let createAt: String
    let updateAt: String
    
    struct Location: Codable{
        let latitude: Double
        let longitude: Double
        let updateAt: String
    }
}
