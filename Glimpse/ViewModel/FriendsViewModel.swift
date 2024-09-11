//
//  FriendsViewModel.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 07/09/2024.
//

import Foundation

class FriendsViewModel {
    
    //MARK: -FriendLists
    var friends: [[String: Any]] = []
    var onFriendsUpdated: (() -> Void)?
    
    func fetchFriends(){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("No auth token found")
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/api/users/getFriendList?token=\(token)") else{
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200{
                print("Server error: Status code \(httpResponse.statusCode)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let friends = json["friends"] as? [[String: Any]]{
                    DispatchQueue.main.async {
                        self.friends = friends
                        self.onFriendsUpdated?()
                    }
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    //MARK: -AddNewFriend
    var searchLst: [[String: Any]] = []
    var onSearchLstUpdated: (() -> Void)?
    
    func findUserByKeyword(keyword: String){
        guard let url = URL(string: "http://localhost:3000/api/users/getUserInfoByUsernameOrEmail?keyword=\(keyword)") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error{
                print(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            if let httpresponse = response as? HTTPURLResponse, httpresponse.statusCode != 200{
                print("server error: Status code \(httpresponse.statusCode)")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let friends = json["users"] as? [[String: Any]]{
                    self.searchLst = friends
                    self.onSearchLstUpdated?()
                    print(self.searchLst)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    
    func sendFriendRequest(receiverId: String){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("token not found")
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/api/friend/sendFriendRequest") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token" : token,
            "receiverId": receiverId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            if let httpresponse = response as? HTTPURLResponse, httpresponse.statusCode != 200{
                print("server error: Status code \(httpresponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("invalid data")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Friend request successfully sent: \(json)")
                }
            } catch {
                print("Failed to parse response: \(error)")
            }
            
        }
        task.resume()
    }
    
    //MARK: -FriendRequest
    var friendRequest: [[String: Any]] = []
    var onFriendRequest: (() -> Void)?
    
    
    func fetchFriendRequest(){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("Can't find token")
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/api/friend/getFriendRequest?token=\(token)") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            if let httpresponse = response as? HTTPURLResponse, httpresponse.statusCode != 200{
                print("server error \(httpresponse.statusCode)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let friendRequest = json["friendRequests"] as? [[String: Any]]{
                    print(friendRequest)
                    self.friendRequest = friendRequest
                    DispatchQueue.main.async {
                        self.onFriendRequest?()
                    }
                }
            }
            catch  {
                print(error)
            }
        }
        task.resume()
        
    }
    
    func addToFriendList(id1: String, id2: String){
        guard let url = URL(string: "http://localhost:3000/api/users/addToFriendList") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let body: [String: Any] = [
            "id1": id1,
            "id2": id2
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("none data")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("\(httpResponse.statusCode)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]{
                    print(json)
                }
                
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
    
    func removeFriendRequest(requestid: String){
        guard let url = URL(string: "http://localhost:3000/api/friend/deleteFriendRequest?id=\(requestid)") else{
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print("No data")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200{
                print("\(httpResponse.statusCode)")
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print(json)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func isFriend(friendId: String, completion: @escaping (Bool) -> Void){
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/api/users/isFriend") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "friendId": friendId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request){data, response, error in
            if let error = error{
                print(error)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("\(httpResponse)")
                return
            }
            
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                if let isFriend = json["isFriend"] as? Bool {
                    print("isFriendVM: \(isFriend)")
                    completion(isFriend)
                } else {
                    completion(false)
                }
            }

            
            
        }
        task.resume()
    }
    
    func isPending(receiverId: String, completion: @escaping (Bool) -> Void) {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            print("invalid token")
            return
        }
        
        guard let url = URL(string: "http://localhost:3000/api/friend/isPending") else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Phải sử dụng POST
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "token": token,
            "receiverId": receiverId
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                print("Response JSON: \(jsonResponse)")
                
                // Kiểm tra nếu có friendRequest đang pending
                if let responseDict = jsonResponse as? [String: Any], let friendRequests = responseDict["friendRequest"] as? [[String: Any]], !friendRequests.isEmpty {
                    completion(true) // Đang pending
                } else {
                    completion(false)
                }
            } catch let parseError {
                print("JSON parse error: \(parseError.localizedDescription)")
            }
        }
        
        task.resume()
    }

    
}
