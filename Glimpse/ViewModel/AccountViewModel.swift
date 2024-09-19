//
//  AccountViewModel.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 11/09/2024.
//

import Foundation

class AccountViewModel{
    func isMe(id: String, completion: @escaping (Bool) -> Void){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else{
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/isMe/") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "id": id
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else {
                print("Invalid data")
                completion(false)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? Bool {
                completion(json)
            } else {
                print("Failed to parse JSON")
                completion(false)
            }
        }
        
        task.resume()
    }
    
    func removeFromFriendList(id: String, completion: @escaping (Bool) -> Void){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/removeFromFriendList") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "friendId": id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print(httpResponse.statusCode)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                if let success = json["success"] as? Bool{
                    completion(success)
                }
            }
            
        }
        task.resume()
    }
    
    func removeRequestOnUsers(id: String, completion: @escaping (Bool) -> Void){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/friend/removeFriendRequestOnUsers") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "id2": id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                let result = json["success"] as! Bool
                completion(result)
            }
            
        }
        task.resume()
    }
    
    func isReceiving(id: String, completion: @escaping (Bool) -> Void){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else{
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/friend/isReceiving") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "receiverId": id
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]{
                let success = json["success"] as! Bool
                print(success)
                completion(success)
            }
        }
        task.resume()
    }
    
    func updateImage(url: String) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else{
            print("invalid token")
            return
        }
        
        guard let requestUrl = URL(string: "https://glimpse-server.onrender.com/api/users/updateImage") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "imageUrl": url // Make sure `url` is a String
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) {
                print(json)
                return
            }
        }
        task.resume() // Make sure to start the task
    }
    
    let mapVM = MapViewModel()
    var user: User!
    var glimpse: [Glimpse] = []
    var ortherGlimpse: [Glimpse] = []
    
    func getUserGlimpse(completion: @escaping () -> Void) {
        mapVM.getUserInfoByToken {user in
            self.user = user
            guard let url = URL(string: "https://glimpse-server.onrender.com/api/glimpse/getUserGlimpse?id=\(self.user._id)") else {
                print("invalid url")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error)
                    return
                }

                guard let data = data else {
                    print("invalid data")
                    return
                }

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                decoder.dateDecodingStrategy = .formatted(dateFormatter)

                do {
                    let glimpses = try decoder.decode([Glimpse].self, from: data)
                    self.glimpse = glimpses // Update the glimpse array
                    completion()
                } catch {
                    print("Decoding error: \(error)")
                }
            }
            task.resume()
        }
    }
    
    func fetchFriendGlimpse(id: String,completion: @escaping () -> Void){
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/glimpse/getUserGlimpse?id=\(id)") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
                return
            }

            guard let data = data else {
                print("invalid data")
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            decoder.dateDecodingStrategy = .formatted(dateFormatter)

            do {
                let glimpses = try decoder.decode([Glimpse].self, from: data)
                self.ortherGlimpse = glimpses // Update the glimpse array
                completion()
            } catch {
                print("Decoding error: \(error)")
            }
        }
        task.resume()
    }


}
