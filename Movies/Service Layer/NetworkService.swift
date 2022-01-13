//
//  MoviesManager.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import Alamofire
import Kingfisher
import UIKit

protocol NetworkServiceProtocol {
    func request<T: Codable>(endPoint: EndPoint,
                             expecting: T.Type,
                             completion: @escaping (Result<T?, Error>) -> Void)
    func setImage(imageURL: String, imageView: UIImageView)
}

class NetworkService: NetworkServiceProtocol {
    //MARK: - Static Constants -
    static let shared = NetworkService()
    
    //MARK: - Life Cycle -
    private init() {}
    
    //MARK: - Internal -
    func request<T: Codable>(endPoint: EndPoint,
                             expecting: T.Type,
                             completion: @escaping (Result<T?, Error>) -> Void) {
        
        let fullURLString = endPoint.fullURLString()
        guard let url = URL(string: fullURLString) else {
            completion(.failure(RequestError.invalidURL))
            return
        }
        
        AF.request(url,
                   method: endPoint.method,
                   parameters: endPoint.parameters,
                   encoding: endPoint.encoding).responseJSON { [ weak self ] responce in
            guard let strongSelf = self else { return }
            guard let safeData = responce.data else {
                if let error = responce.error {
                    completion(.failure(error))
                } else {
                    completion(.failure(RequestError.invalidData))
                }
                return
            }
            
            let result = strongSelf.parseJson(safeData, expecting: expecting)
            completion(.success(result))
        }
    }
    
    func setImage(imageURL: String, imageView: UIImageView) {
        let baseURL = "https://image.tmdb.org/t/p"
        let imageSize = "/w500"
        let mainURL = baseURL + imageSize + imageURL
        let url = URL(string: mainURL)
        imageView.kf.setImage(with: url)
    }
    
    //MARK: - Private -
    private func parseJson<T: Codable>(_ data: Data,
                           expecting: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(expecting, from: data)
            return decodateData
        } catch {
            return nil
        }
    }
    
    private enum RequestError: Error {
        case invalidURL
        case invalidData
    }
}
