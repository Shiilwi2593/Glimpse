//
//  LoginViewModel.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 25/08/2024.
//

import Foundation

class LoginViewModel{
    func login(email: String, password: String, completion: @escaping (Bool, String?) -> Void){
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/login") else{
            completion(false, nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        let task = URLSession.shared.dataTask(with: request){ data, respond,error in
            if let error = error {
                print("Login error: \(error)")
                completion(false, nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(false, nil)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("JSON Response: \(String(describing: json))")
                if let token = json?["token"] as? String {
                    completion(true, token)
                } else {
                    completion(false, nil)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
            
        }
        task.resume()
        
    }
    
    
}
