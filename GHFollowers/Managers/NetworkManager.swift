//
//  NetworkManager.swift
//  GHFollowers
//
//  Created by Danilo on 31/10/22.
//

import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = "https://api.github.com/"
    
    ///creo un'istanza della cache qui dato che network manager è un singleton
    let cache = NSCache<NSString, UIImage>()
    
    private init(){}
    
    //                                                                                  strings converted
    //                                                                                to enumerated messages
    //                                                                                          |
    //                                                                                          |
    //                                                                                          V
    func getFollowers(for username: String, page: Int, completed: @escaping (Result<[Follower],GFError>) -> Void) {
        
        let endpoint = baseURL + "users/\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
//                print(error ?? "error")

                completed(.failure(.unableToComplete)) //connection error
                return
            }
            
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

                completed(.failure(.invalidResponse)) //server error: ≠ 200
                return
            }
            
            
            guard let data = data else {
                completed(.failure(.invalidData)) //data nil
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(.success(followers)) //response & data & json decode OK
            } catch {
                print(error)
                completed(.failure(.invalidData)) //deconding error
            }
            
            
            
        }
        
        task.resume()
    }
    
    func getUserInfo(for username: String, completed: @escaping (Result<User,GFError>) -> Void) {
        
        let endpoint = baseURL + "users/\(username)"
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUsername))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
//                print(error ?? "error")

                completed(.failure(.unableToComplete)) //connection error
                return
            }
            
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {

                completed(.failure(.invalidResponse)) //server error: ≠ 200
                return
            }
            
            
            guard let data = data else {
                completed(.failure(.invalidData)) //data nil
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(User.self, from: data)
                completed(.success(user)) //response & data & json decode OK
            } catch {
                print(error)
                completed(.failure(.invalidData)) //deconding error
            }
            
            
            
        }
        
        task.resume()
    }
    
    
}
