//
//  MoviesManager.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import Foundation

protocol MoviesManagerProtocol {
    func getComments(completion: @escaping (Result<[Movie]?, Error>) -> Void)
}
