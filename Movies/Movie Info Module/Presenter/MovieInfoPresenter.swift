//
//  MovieInfoPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 14.01.2022.
//

import UIKit

protocol MovieInfoViewProtocol: AnyObject {
    func setMovieInfo(_ model: MovieDetailsData)
    func showMoviePoster()
    func showMovieVideo(with id: String)
    func showErrorAlert(with message: String)
}

protocol MovieInfoViewPresenterProtocol: AnyObject {
    init(view: MovieInfoViewProtocol, router: RouterProtocol, movieID: Int?)
    func viewDidLoad()
}

class MovieInfoPresenter: MovieInfoViewPresenterProtocol {
    //MARK: - Variables -
    weak var view: MovieInfoViewProtocol?
    var router: RouterProtocol?
    let movieID: Int?
    
    //MARK: - Life Cycle -
    required init(view: MovieInfoViewProtocol, router: RouterProtocol, movieID: Int?) {
        self.view = view
        self.router = router
        self.movieID = movieID
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getMovieInfo()
        getMovieTrailerLink()
    }
    
    func getMovieInfo() {
        guard let movieID = movieID else {
            return
        }
        let endPoint = EndPoint.movieDetails(id: movieID)
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieDetailsData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let moviesArray = data else {return}
                    strongSelf.view?.setMovieInfo(moviesArray)
                case.failure(let error):
                    let message = "Failed to get info about movie: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
    
    func getMovieTrailerLink() {
        guard let movieID = movieID else {
            return
        }
        let endPoint = EndPoint.movieTrailer(id: movieID)
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieTrailerData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let video = data?.results, !video.isEmpty else {
                        strongSelf.view?.showMoviePoster()
                        return
                    }

                    let id = video[0].key
                    strongSelf.view?.showMovieVideo(with: id)
                case.failure(_):
                    strongSelf.view?.showMoviePoster()
                }
            }
        }
    }
}

