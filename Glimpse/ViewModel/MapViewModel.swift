//
//  MapViewModel.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 25/08/2024.
//

import Foundation

class MapViewModel{
    
   func getUserInfoByToken(token: String, completion: @escaping (User?) -> Void) {
       guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/getUserInfoByToken/\(token)") else {
           print("Invalid URL")
           completion(nil)
           return
       }
       
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       
       // Tạo task để thực hiện request
       let task = URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               print("Request error: \(error)")
               completion(nil)
               return
           }
           
           guard let data = data else {
               print("No data received")
               completion(nil)
               return
           }
           
           do {
               let user = try JSONDecoder().decode(User.self, from: data)
               completion(user)
           } catch {
               print("Failed to decode response: \(error)")
               completion(nil)
           }
       }
       
       task.resume()
   }

    func updateLocation(token: String, latitude: Double, longitude: Double, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/updateLocation") else {
            completion(false, "Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT" // Changed to PUT
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["token": token, "latitude": latitude, "longitude": longitude] as [String : Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error updating location: \(error)")
                completion(false, error.localizedDescription)
                return
            }

            guard let data = data else {
                completion(false, "No data received")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let success = json["success"] as? Bool {
                    completion(success, json["message"] as? String)
                } else {
                    completion(false, "Invalid response")
                }
            } catch {
                print("Error parsing JSON: \(error)")
                completion(false, "Error parsing JSON")
            }
        }
        task.resume()
    }
    
}
