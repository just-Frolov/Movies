//
//  EndPoint.swift
//  Movies
//
//  Created by Данил Фролов on 13.01.2022.
//

import Alamofire

private struct Constants {
    static let baseURL = "https://api.themoviedb.org/3/"
    static let kApiKey = "api_key="
    static let apiKey = "a5e9b83ceecaed49515d68d344c79b72"
    static let kLanguage = "language="
    static let language = "ru"
}

enum EndPoint {
    case list(sort: String, page: Int)
    case genres
    case searchMovies(query: String, page: Int)
    case movieDetails(id: Int)
    case movieTrailer(id: Int)
    
    var path: String {
        switch self {
        case .list:
            return "discover/movie"
        case .genres:
            return "genre/movie/list"
        case .searchMovies:
            return "search/movie"
        case .movieDetails(let id):
            return "movie/\(id)"
        case .movieTrailer(let id):
            return "movie/\(id)/videos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list,
                .genres,
                .searchMovies,
                .movieDetails,
                .movieTrailer:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .list,
                .genres,
                .searchMovies,
                .movieDetails,
                .movieTrailer:
            return URLEncoding.default
//        default:
//            return JSONEncoding.default
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .list(sort: let sort, page: let page):
            return ["page": page, "sort_by": sort]
        case .genres:
            return ["": ""]
        case .searchMovies(query: let query, page: let page):
            return ["query": query, "page": page]
        case .movieDetails(_):
            return ["": ""]
        case .movieTrailer(_):
            return ["": ""]
        }
    }
    
    func fullURLString() -> String {
        return String(format: "%@%@?%@%@&%@%@",
                      Constants.baseURL,
                      self.path,
                      Constants.kApiKey,
                      Constants.apiKey,
                      Constants.kLanguage,
                      Constants.language)
    }
}
