//
//  MovieTrailerPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 16.01.2022.
//

import UIKit

protocol MovieTrailerViewProtocol: AnyObject {
    func showErrorLabel()
    func playMovieVideo(with id: String)
    func showError(with message: String)
}

protocol MovieTrailerViewPresenterProtocol: AnyObject {
    init(view: MovieTrailerViewController, router: RouterProtocol, movieID: Int?)
    func viewDidLoad()
    func getMovieTrailerLink()
}

class MovieTrailerPresenter: MovieTrailerViewPresenterProtocol {
    //MARK: - Variables -
    weak var view: MovieTrailerViewController?
    var router: RouterProtocol?
    let movieID: Int?
    
    //MARK: - Life Cycle -
    required init(view: MovieTrailerViewController, router: RouterProtocol, movieID: Int?) {
        self.view = view
        self.router = router
        self.movieID = movieID
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        getMovieTrailerLink()
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
                        strongSelf.view?.showErrorLabel()
                        return
                    }

                    let id = video[0].key
                    strongSelf.view?.playMovieVideo(with: id)
                case.failure(let error):
                    let message = "Failed to get trailer to movie: \(error)"
                    strongSelf.view?.showError(with: message)
                }
            }
        }
    }
}

