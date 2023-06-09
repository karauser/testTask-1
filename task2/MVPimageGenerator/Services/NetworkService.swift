//
//  NetworkService.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//


import UIKit

protocol NetworkProtocol {
    func generateImage(with query: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class NetworkService: NetworkProtocol {
    private var requestCallbacks: [String: [(Result<UIImage, Error>) -> Void]] = [:]
    private var requestCache: [String: UIImage] = [:]
    
    func generateImage(with query: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        if let cachedImage = requestCache[query] {
            completion(.success(cachedImage))
            return
        }
        
        if requestCallbacks[query] == nil {
            requestCallbacks[query] = []
        }

        requestCallbacks[query]?.append(completion)
        
        if requestCallbacks[query]?.count == 1 {
            sendRequest(with: query)
        }
    }
    
    private func sendRequest(with query: String) {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            handleRequestCompletion(with: .failure(NetworkError.invalidURL), for: query)
            return
        }
        
        let urlString = "https://dummyimage.com/500x500&text=\(encodedQuery)"
        guard let url = URL(string: urlString) else {
            handleRequestCompletion(with: .failure(NetworkError.invalidURL), for: query)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.handleRequestCompletion(with: .failure(error), for: query)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                self.handleRequestCompletion(with: .failure(NetworkError.invalidResponse), for: query)
                return
            }
            
            self.requestCache[query] = image
            self.handleRequestCompletion(with: .success(image), for: query)
        }.resume()
    }
    
    private func handleRequestCompletion(with result: Result<UIImage, Error>, for query: String) {
        guard let completions = requestCallbacks.removeValue(forKey: query) else { return }
        completions.forEach { completion in
            completion(result)
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}

