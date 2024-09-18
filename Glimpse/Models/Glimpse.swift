//
//  File.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 18/09/2024.
//

import Foundation

struct GlimpseData: Codable {
    let userId: String
    let image: String
    let location: Location
    
    struct Location: Codable {
        let latitude: Double
        let longitude: Double
    }
}
