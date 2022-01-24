//
//  AssemblerModuleBuilder.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

protocol AssemblerBuilderProtocol {
    func createMovieListModule(router: RouterProtocol) -> UIViewController
    func createMovieInfoModule(router: RouterProtocol, movieID: Int?) -> UIViewController
    func createMoviePosterModule(router: RouterProtocol, image: UIImage) -> UIViewController
}

class AssemblerModuleBuilder: AssemblerBuilderProtocol {
    func createMovieListModule(router: RouterProtocol) -> UIViewController {
        let view = MovieListViewController()
        let presenter = MovieListPresenter(view: view,
                                           router: router)
        view.presenter = presenter
        return view
    }
    
    func createMovieInfoModule(router: RouterProtocol, movieID: Int?) -> UIViewController {
        let view = MovieInfoViewController()
        let presenter = MovieInfoPresenter(view: view,
                                           router: router,
                                           movieID: movieID)
        view.presenter = presenter
        return view
    }
    
    func createMoviePosterModule(router: RouterProtocol, image: UIImage) -> UIViewController {
          let view = MoviePosterViewController()
          let presenter = MoviePosterPresenter(view: view,
                                             router: router,
                                             image: image)
          view.presenter = presenter
          return view
      }
}
