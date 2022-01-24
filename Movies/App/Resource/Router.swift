//
//  Router.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var assemblyBuilder: AssemblerBuilderProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    func showMovieDetails(by movieID: Int)
    func showPosterInFullScreen(image: UIImage)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemblyBuilder: AssemblerBuilderProtocol?
    
    init(navigationController: UINavigationController, assemblyBuilder: AssemblerBuilderProtocol) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let viewController = assemblyBuilder?.createMovieListModule(router: self) else { return }
            navigationController.viewControllers = [viewController]
        }
    }
    
    func showMovieDetails(by movieID: Int) {
        if let navigationController = navigationController {
            guard let infoViewController = assemblyBuilder?.createMovieInfoModule(router: self,
                                                                                  movieID: movieID) else { return }
            navigationController.pushViewController(infoViewController, animated: true)
        }
    }
    
    func showPosterInFullScreen(image: UIImage) {
        if let navigationController = navigationController {
            guard let videoViewController = assemblyBuilder?.createMoviePosterModule(router: self,
                                                                                     image: image) else { return }
            navigationController.pushViewController(videoViewController, animated: true)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
