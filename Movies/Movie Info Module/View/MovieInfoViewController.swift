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
    
    private lazy var movieRatingBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 242/255,
                                       green: 245/255,
                                       blue: 245/255,
                                       alpha: 1)
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height: -2.0)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 0.15
        view.addSubview(movieRatingLabel)
        view.addSubview(ratingResourceLabel)
        return view
    }()
    
    private lazy var ratingResourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 190/255,
                                  green: 190/255,
                                  blue: 190/255,
                                  alpha: 1)
        label.text = "IMDB"
        return label
    }()
    
    private lazy var movieRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .light)
    
    //MARK: - Variables -
    var presenter: MovieInfoPresenter!
    var movieID: Int!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
        addSubViews()
        setupConstraints()
    }
    
    //MARK: - Private -
    private func addSubViews() {
        view.addSubview(moviePoster)
        view.addSubview(movieRatingBackgroundView)
        view.addSubview(movieRatingLabel)
    }
    
    private func setupConstraints() {
        setupMoviePosterConstraints()
        setupRatingBackgroundViewConstraints()
        setupMovieRatingLabelConstraints()
        setupRatingResourceLabelConstraints()
    }
    
    private func setupMoviePosterConstraints() {
        moviePoster.snp.makeConstraints { make in
            make.top.equalTo(view).offset(90)
            make.width.equalTo(view)
            make.height.lessThanOrEqualTo(200)
        }
    }
    
    private func setupRatingBackgroundViewConstraints() {
        movieRatingBackgroundView.snp.makeConstraints { make in
            make.centerX.equalTo(moviePoster)
            make.centerY.equalTo(moviePoster.snp_bottomMargin).offset(25)
            make.width.equalToSuperview().dividedBy(3.5)
            make.height.equalTo(50)
        }
    }
    
    private func setupMovieRatingLabelConstraints() {
        movieRatingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(movieRatingBackgroundView)
            make.topMargin.equalTo(movieRatingBackgroundView.snp_topMargin).offset(5)
        }
    }
    
    private func setupRatingResourceLabelConstraints() {
        ratingResourceLabel.snp.makeConstraints { make in
            make.centerX.equalTo(movieRatingLabel)
            make.centerY.equalTo(movieRatingLabel.snp_bottomMargin).offset(17)
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        showSpinner(spinner)
    }
}


extension MovieInfoViewController: MovieInfoViewProtocol {
    func setMovieInfo(_ model: MovieDetailsData) {
        self.hideSpinner(self.spinner)
        self.title = model.title
        self.movieRatingLabel.text = String(model.voteAverage)
        
        
        if let poster = model.backdropPath {
            NetworkService.shared.setImage(imageURL: poster, imageView: self.moviePoster)
        } else {
            self.moviePoster.image = UIImage(systemName: "xmark.circle")
            self.moviePoster.tintColor = .black
        }
    }
    
    func showErrorAlert(with message: String) {
        showAlert("Error", with: message)
    }
}
