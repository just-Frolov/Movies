//
//  MovieInfoPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 14.01.2022.
//

import UIKit

protocol MovieInfoViewProtocol: AnyObject {
    func setMovieInfo(from movieDetails: MovieDetailsData)
    func showMoviePoster()
    func showMovieVideo(with id: String)
    func showErrorAlert(with message: String)
    func updateSections(_ sections: [InfoTableSectionModel])
}

protocol MovieInfoViewPresenterProtocol: AnyObject {
    init(view: MovieInfoViewProtocol, router: RouterProtocol, movieID: Int?)
    func viewDidLoad()
    func showPosterInFullScreen(image: UIImage)
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
    
    func showPosterInFullScreen(image: UIImage) {
        router?.showPosterInFullScreen(image: image)
    }
    
    private func getMovieInfo() {
        guard let movieID = movieID else {
            return
        }
        let endPoint = EndPoint.movieDetails(id: movieID)
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieDetailsData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let movieDetails = data else {return}
                    let tableViewSectionTypes = strongSelf.assembleModels()
                    strongSelf.view?.setMovieInfo(from: movieDetails)
                    strongSelf.view?.updateSections(tableViewSectionTypes)
                case.failure(let error):
                    let message = "Failed to get info about movie: \(error)"
                    strongSelf.view?.showErrorAlert(with: message)
                }
            }
        }
    }
    
    private func getMovieTrailerLink() {
        guard let movieID = movieID else {
            return
        }
        let endPoint = EndPoint.movieTrailer(id: movieID)
        NetworkService.shared.request(endPoint: endPoint, expecting: MovieTrailerData.self) { [weak self] result in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case.success(let data):
                    guard let videoList = data?.results, !videoList.isEmpty else {
                        strongSelf.view?.showMoviePoster()
                        return
                    }
                    let firstVideo = 0
                    let id = videoList[firstVideo].key
                    strongSelf.view?.showMovieVideo(with: id)
                case.failure(_):
                    strongSelf.view?.showMoviePoster()
                }
            }
        }
    }
    
    private func assembleModels() -> [InfoTableSectionModel] {
        let genreSectionModel = InfoTableSectionModel(type: .genres, cellTypes: [.genres])
        let descriptionSectionModel = InfoTableSectionModel(type: .description, cellTypes: [.description])
        let ratingSectionModel = InfoTableSectionModel(type: .rating, cellTypes: [.rating])
        let originalTitleSectionModel = InfoTableSectionModel(type: .originalTitle, cellTypes: [.originalTitle])
        let releaseDateSectionModel = InfoTableSectionModel(type: .releaseDate, cellTypes: [.releaseDate])
        let budgetSectionModel = InfoTableSectionModel(type: .budget, cellTypes: [.budget])
        return [genreSectionModel, descriptionSectionModel, ratingSectionModel, originalTitleSectionModel, releaseDateSectionModel, budgetSectionModel]
    }
}

