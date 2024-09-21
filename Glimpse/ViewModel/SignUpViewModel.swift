//
//  SignUpViewModel.swift
//  Glimpse
//
//  Created by Trịnh Kiết Tường on 24/08/2024.
//

import Foundation

class SignUpViewModel {
    func checkEmailAvailability(email: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "https://glimpse-server.onrender.com/api/users/checkEmail")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(false, "Connection error")
                return
            }
            
            if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let exists = responseDict["exists"] as? Bool {
                let message = responseDict["msg"] as? String
                completion(exists, message)
            } else {
                completion(false, "Response error")
            }
        }.resume()
    }
    
    func checkUsernameAvailability(username: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "https://glimpse-server.onrender.com/api/users/checkUsername")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": username]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(false, "Connection error")
                return
            }
            
            if let responseDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let exists = responseDict["exists"] as? Bool {
                let message = responseDict["msg"] as? String
                completion(exists, message)
            } else {
                completion(false, "Response error")
            }
        }.resume()
    }
    
    func signUp(username: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        let url = URL(string: "https://glimpse-server.onrender.com/api/users/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": username, "email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(false, "Connection error: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    completion(false, "No data received from server")
                    return
                }
                
                // Log the raw response
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw server response: \(rawResponse)")
                }
                
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        if let success = responseDict["success"] as? Bool {
                            let message = responseDict["msg"] as? String ?? responseDict["message"] as? String
                            completion(success, message)
                        } else {
                            completion(false, "Unexpected response format")
                        }
                    } else {
                        completion(false, "Unable to parse server response")
                    }
                } catch {
                    completion(false, "Error parsing response: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    func sendOTP(to email: String, completion: @escaping (Bool, String?, String?) -> Void) {
        guard let url = URL(string: "https://glimpse-server.onrender.com/api/users/sendOTP") else {
            completion(false, "Invalid URL", nil)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["email": email]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                }
                
                guard let data = data, error == nil else {
                    completion(false, "Connection error", nil)
                    return
                }
                
                if let rawResponse = String(data: data, encoding: .utf8) {
                    print("Raw server response: \(rawResponse)")
                }
                
                do {
                    if let responseDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        let success = responseDict["success"] as? Bool ?? false
                        let otp = responseDict["otp"] as? Int ?? 0
                        let message = responseDict["message"] as? String
                        
                        completion(success, message, "\(otp)")
                    } else {
                        completion(false, "Unexpected response format", nil)
                    }
                } catch {
                    completion(false, "Error parsing response: \(error.localizedDescription)", nil)
                }
            }
        }.resume()
        
    }
    
}
