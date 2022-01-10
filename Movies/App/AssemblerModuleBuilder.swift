//
//  AsselderModuleBuilder.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import UIKit

protocol AssemblerBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(router: RouterProtocol) -> UIViewController
}

class AssemblerModuleBuilder: AssemblerBuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MovieListViewController()
        //let networkService = NetworkService()
//        let presenter = MovieListPresenter(view: view,
//                                      networkService: networkService,
//                                      router: router)
//        view.presenter = presenter
        return view
    }
    
    func createDetailModule(router: RouterProtocol) -> UIViewController {
        let view = MovieListViewController()
//        let networkService = NetworkService()
//        let presenter = DetailPresenter(view: view,
//                                        networkService: networkService, router: router,
//                                        comment: comment)
//        view.presenter = presenter
        return view
    }
}
