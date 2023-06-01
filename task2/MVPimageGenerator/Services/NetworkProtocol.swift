//
//  ImageService.swift
//  MVPimageGenerator
//
//  Created by Sergey on 21/05/23.
//


import UIKit

protocol NetworkProtocol {
    func generateImage(with query: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class NetworkService: NetworkProtocol {
    func generateImage(with query: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        let urlString = "https://dummyimage.com/500x500&text=\(query)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                
                if let image = UIImage(data: data) {
                    completion(.success(image))
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            } catch {
                completion(.failure(NetworkError.requestFailed))
            }
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
}

