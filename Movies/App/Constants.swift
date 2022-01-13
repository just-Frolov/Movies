//
//  Constants.swift
//  Movies
//
//  Created by Данил Фролов on 13.01.2022.
//

import Alamofire

struct Constants {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let apiKey = "a5e9b83ceecaed49515d68d344c79b72"
    static let kApiKey = "api_key="
    static let language = "ru"
}

enum EndPoint {
    case popular(page: Int)
    case searchMovies(query: String)
    
    var path: String {
        switch self {
        case .popular:
            return "movie/popular"
        case .searchMovies:
            return "search/movie"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .popular,
                .searchMovies:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .popular,
                .searchMovies:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .popular(page: let page):
            return ["page": page]
        case .searchMovies(query: let query):
            return ["query": query]
        }
    }
    
    func fullURLString() -> String {
        return String(format: "%@%@?api_key=%@&language=%@",
                      Constants.baseURL,
                      self.path,
                      Constants.apiKey,
                      Constants.language)
    }
}
