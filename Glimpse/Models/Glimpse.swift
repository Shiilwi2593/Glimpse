//
//  File.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 18/09/2024.
//

import Foundation

struct Glimpse: Decodable {
    let id: String
    let userId: String
    let image: String
    let likes: [String]
    let createAt: Date
    let location: Location
    
    
    struct Location: Decodable {
        let latitude: Double
        let longitude: Double
    }
    
    enum CodingKeys: String, CodingKey{
        case id = "_id"
        case userId
        case image
        case likes
        case createAt
        case location
    }
}
