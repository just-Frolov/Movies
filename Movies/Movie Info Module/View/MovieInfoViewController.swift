//
//  MovieInfoViewController.swift
//  Movies
//
//  Created by Данил Фролов on 14.01.2022.
//

import SnapKit
import JGProgressHUD

class MovieInfoViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .dark)
    
    //MARK: - Variables -
    var presenter: MovieInfoPresenter!
    var movieID: Int!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubViews()
        setupConstraints()
        setupView()
        presenter.viewDidLoad()
    }
    
    //MARK: - Private -
    private func setupView() {
        view.backgroundColor = .white
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Movie Information"
        configureItems()
    }
    
    private func configureItems() {
        
    }
    
    private func addSubViews() {
        
    }
    
    private func setupConstraints() {
        
    }
}


extension MovieInfoViewController: MovieInfoViewProtocol {
    func setMovieInfo(_ moviesArray: MovieDetailsData) {
        
    }
    
    func showErrorAlert(with message: String) {
        showAlert("Error", with: message)
    }
}
