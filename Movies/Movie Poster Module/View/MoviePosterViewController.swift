//
//  MoviePosterViewController.swift
//  Movies
//
//  Created by Данил Фролов on 21.01.2022.
//

import SnapKit


class MoviePosterViewController: UIViewController {
    //MARK: - UI Elements -
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        return image
    }()
    
    //MARK: - Variables -
    var presenter: MoviePosterViewPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Poster"
        addSubview()
        setupMoviePosterConstraints()
        presenter.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        moviePoster.isHidden = true
    }
    
    //MARK: - Private -
    private func addSubview() {
        view.addSubview(moviePoster)
    }
    
    private func setupMoviePosterConstraints() {
        moviePoster.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.centerY.equalToSuperview()
        }
    }
}

extension MoviePosterViewController: MoviePosterViewProtocol {
    func showPoster(image: UIImage) {
        moviePoster.image = image
    }
}
