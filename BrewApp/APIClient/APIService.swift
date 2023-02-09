//
//  APIService.swift
//  BrewApp
//
//  Created by Emerson Balahan Varona on 8/2/23.
//

import Foundation

struct Constants {
    static let baseUrl = URL(string: "https://api.punkapi.com/v2/beers")
}

extension URLSession {
    enum CustomError: Error {
        case invalidUrl
        case invalidData
    }
    
    func request<T: Codable>(
        url: URL?,
        expecting: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = url else {
            completion(.failure(CustomError.invalidUrl))
            return
        }
        
        let task = dataTask(with: url) { data, _, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.failure(CustomError.invalidData))
                }
                return
            }
            
            do {
                let result = try JSONDecoder().decode(expecting, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func searchBeer(with name: String, completion: @escaping (Result<[BABeer], Error>) -> Void) {
        guard let name = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?beer_name=\(name)") else {
            return
        }
        
        request(url: url, expecting: [BABeer].self) { result in
            completion(result)
        }
    }
    
    func getBeer(with name: String, completion: @escaping (Result<[BABeer], Error>) -> Void) {
        guard let name = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
        
        guard let url = URL(string: "https://api.punkapi.com/v2/beers?beer_name=\(name)") else {
            return
        }
        
        request(url: url, expecting: [BABeer].self) { result in
            completion(result)
        }
    }
    
}
