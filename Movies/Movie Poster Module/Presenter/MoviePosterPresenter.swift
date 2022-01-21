//
//  MoviePosterPresenter.swift
//  Movies
//
//  Created by Данил Фролов on 21.01.2022.
//

import UIKit

protocol MoviePosterViewProtocol: AnyObject {
    func showPoster(image: UIImage)
}

protocol MoviePosterViewPresenterProtocol: AnyObject {
    init(view: MoviePosterViewController, router: RouterProtocol, image: UIImage)
    func viewDidLoad()
}

class MoviePosterPresenter: MoviePosterViewPresenterProtocol {
    //MARK: - Variables -
    weak var view: MoviePosterViewController?
    var router: RouterProtocol?
    let image: UIImage!
    
    //MARK: - Life Cycle -
    required init(view: MoviePosterViewController, router: RouterProtocol, image: UIImage) {
        self.view = view
        self.router = router
        self.image = image
    }
    
    //MARK: - Internal -
    func viewDidLoad() {
        view?.showPoster(image: image)
    }
}

