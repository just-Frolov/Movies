//
//  MovieInfoPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 14.01.2022.
//

import UIKit

protocol MovieInfoViewProtocol: AnyObject {
    func setMovieInfo(_ moviesArray: [Movie])
    func showErrorAlert(with message: String)
}

protocol MovieInfoViewPresenterProtocol: AnyObject {
    init(view: MovieInfoViewProtocol, router: RouterProtocol)
    func getMovieInfo()
    func tapOnThePoster(movieID: Int)
}

class MovieInfoPresenter: MovieInfoViewPresenterProtocol {
    //MARK: - Variables -
    weak var view: MovieInfoViewProtocol?
    var router: RouterProtocol
    
    //MARK: - Life Cycle -
    required init(view: MovieInfoViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getMovieInfo()
    }
    
    func getMovieInfo() {
        let movieInfoPage = 1
        let endPoint = EndPoint.popular(page: movieInfoPage)
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let moviesArray = data?.results else {return}
                    strongSelf.view?.setMovieInfo(moviesArray)
                case.failure(let error):
                    let message = "Failed to get movies: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
    
    func tapOnThePoster(movieID: Int) {
        router.showInfo(by: movieID)
    }
}

