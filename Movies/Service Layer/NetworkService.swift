//
//  MoviesManager.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import Alamofire

protocol NetworkServiceProtocol {
    func getMovies(completion: @escaping (Result<[Movie]?, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    //MARK: - Static Constants -
    static let shared = NetworkService()
    
    //MARK: - Private Constants -
    private let baseURL = "https://api.themoviedb.org/3/movie/popular"
    private let apiKey = "a5e9b83ceecaed49515d68d344c79b72"
    private let language = "uk"
    
    //MARK: - Variables -
    private var page = 1
    
    //MARK: - Life Cycle -
    private init() {}
    
    //MARK: - Internal -
    func getMovies(completion: @escaping (Result<[Movie]?, Error>) -> Void) {
        let urlString = createURLString()
        
        AF.request(urlString).responseJSON { [ weak self ] responce in
            guard responce.error == nil else {
                completion(.failure(RequestError.failedCreateUrl))
                return
            }
            if let safeData = responce.data {
                let movies = self?.parseJson(safeData)
                completion(.success(movies))
            } else {
                completion(.failure(RequestError.failedResponseJSON))
            }
        }
    }
    
    private func createURLString() -> String {
        let url = baseURL + "?api_key=" + apiKey + "&language=" + language + "&page=" + "\(page)"
        return url
    }
    
    private func parseJson(_ data: Data) -> [Movie] {
        let decoder = JSONDecoder()
        do {
            let decodateData = try decoder.decode(MovieData.self, from: data)
            return decodateData.data
        } catch {
            return []
        }
    }
    
    //MARK: - Private -
    private enum RequestError: Error {
        case failedResponseJSON
        case failedCreateUrl
    }
}
