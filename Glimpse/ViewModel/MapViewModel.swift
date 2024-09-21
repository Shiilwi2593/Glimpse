//
//  MapViewModel.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 25/08/2024.
//

import Foundation

class MapViewModel{
    //MARK: -MAP
    func getUserInfoByToken(completion: @escaping (User?) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/getUserInfoByToken/\(token)") else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
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
        request.httpMethod = "PUT" 
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
    
    func fetchFriendsLocation(completion: @escaping ([[String: Any]]?) -> Void){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/fetchFriendsLocation?token=\(token)") else {
            print("invalid token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let httpresponse = response as? HTTPURLResponse, httpresponse.statusCode != 200{
                print(httpresponse.statusCode)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    let friends = json["friends"] as? [[String: Any]]
                    completion(friends)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    //MARK: -Glimpse
    func uploadGlimpse(image: String){
        getUserInfoByToken{ user in
            guard let url = URL(string: "https://glimpse-server.onrender.com/api/glimpse/postGlimpse") else {
                print("invalid url")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let body: [String: Any] = [
                "userId" : user!._id,
                "image" : image,
                "latitude": user!.location.latitude,
                "longitude": user!.location.longitude
            ]
            
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            
            let task = URLSession.shared.dataTask(with: request){data, response, error in
                if let error = error{
                    print(error)
                    return
                }
                
                guard let data = data else {
                    print("invalid data")
                    return
                }
                
                if let json = try? JSONSerialization.jsonObject(with: data){
                    print(json)
                }
            }
            task.resume()
        }
    }
    
    
    
    
}
