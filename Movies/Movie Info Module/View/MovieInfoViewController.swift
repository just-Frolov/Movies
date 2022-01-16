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
    
    private lazy var movieTrailerButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "play.circle.fill"),
                        for: .normal)
        button.imageView?.tintColor = .red
        button.layer.cornerRadius = 20
        button.addTarget(self,
                         action: #selector(trailerButtonPressed),
                         for: .touchUpInside)
        return button
    }()
    
    private lazy var movieRatingBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 242/255,
                                       green: 245/255,
                                       blue: 245/255,
                                       alpha: 1)
//        view.layer.shadowColor = UIColor.black.cgColor
//        view.layer.shadowOffset = CGSize(width: 0.0,
//                                         height: -2.0)
//        view.layer.shadowRadius = 2.0
//        view.layer.shadowOpacity = 0.15
        view.addSubview(movieRatingLabel)
        view.addSubview(ratingResourceLabel)
        return view
    }()
    
    private lazy var movieRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20,
                                 weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var ratingResourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.textColor = UIColor(red: 170/255,
                                  green: 170/255,
                                  blue: 170/255,
                                  alpha: 1)
        label.text = "IMDB"
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.addSubview(movieInfoView)
        return scrollView
    }()
    
    private lazy var movieInfoView: UIView = {
        let view = UIView()
        view.addSubview(movieTitleLabel)
        view.addSubview(movieGenresLabel)
        view.addSubview(movieOverviewLabel)
        view.addSubview(kMovieOriginalTitleLabel)
        view.addSubview(movieOriginalTitleLabel)
        view.addSubview(kMovieReleaseDateLabel)
        view.addSubview(movieReleaseDateLabel)
        view.addSubview(kMovieProductionCountriesLabel)
        view.addSubview(movieProductionCountriesLabel)
        view.addSubview(kMovieBudgetLabel)
        view.addSubview(movieBudgetLabel)
        return view
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var movieGenresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var movieOverviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.textColor = .black
        return label
    }()
    
    private lazy var kMovieOriginalTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Оригинальное название"
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var movieOriginalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var kMovieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата релиза"
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var movieReleaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var kMovieProductionCountriesLabel: UILabel = {
        let label = UILabel()
        label.text = "Производство"
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var movieProductionCountriesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    private lazy var kMovieBudgetLabel: UILabel = {
        let label = UILabel()
        label.text = "Бюджет"
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var movieBudgetLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    //MARK: - Constants -
    private let spinner = JGProgressHUD(style: .light)
    
    //MARK: - Variables -
    var presenter: MovieInfoViewPresenterProtocol!
    
    //MARK: - Life Cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
        addSubViews()
        setupConstraints()
    }
    
    //MARK: - Private -
    private func setupView() {
        navigationController?.navigationBar.topItem?.title = " ";
        view.backgroundColor = .white
        showSpinner(spinner)
    }
    
    private func addSubViews() {
        view.addSubview(moviePoster)
        view.addSubview(movieTrailerButton)
        view.addSubview(movieRatingBackgroundView)
        view.addSubview(scrollView)
    }
    
    private func setupConstraints() {
        setupMoviePosterConstraints()
        setupMovieTrailerButtonConstraints()
        setupRatingBackgroundViewConstraints()
        setupMovieRatingLabelConstraints()
        setupRatingResourceLabelConstraints()
        setupScrollViewConstraints()
        setupMovieInfoViewConstraints()
        setupMovieTitleLabelConstraints()
        setupMovieGenresLabelConstraints()
        setupMovieOverviewLabelConstraints()
        setupKOriginalTitleLabelConstraints()
        setupOriginalTitleLabelConstraints()
        setupKReleaseDataLabelConstraints()
        setupReleaseDataLabelConstraints()
        setupKProductionCountriesLabelConstraints()
        setupProductionCountriesLabelConstraints()
        setupKBudgetLabelConstraints()
        setupBudgetLabelConstraints()
    }
    
    private func setupMoviePosterConstraints() {
        moviePoster.snp.makeConstraints { make in
            make.top.equalTo(view.snp_topMargin)
            make.width.equalToSuperview()
            make.height.lessThanOrEqualTo(200)
        }
    }
    
    private func setupMovieTrailerButtonConstraints() {
        movieTrailerButton.snp.makeConstraints { make in
            make.center.equalTo(moviePoster)
            make.height.width.equalTo(40)
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
    
    private func setupScrollViewConstraints() {
        scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(moviePoster.snp_bottomMargin).offset(80)
        }
    }
    
    private func setupMovieInfoViewConstraints() {
        movieInfoView.snp.makeConstraints { make in
            make.height.equalTo(scrollView)
            make.left.right.equalTo(view).inset(20)
        }
    }
    
    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    private func setupMovieGenresLabelConstraints() {
        movieGenresLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupMovieOverviewLabelConstraints() {
        movieOverviewLabel.snp.makeConstraints { make in
            make.top.equalTo(movieGenresLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupKOriginalTitleLabelConstraints() {
        kMovieOriginalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(movieOverviewLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupOriginalTitleLabelConstraints() {
        movieOriginalTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(kMovieOriginalTitleLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupKReleaseDataLabelConstraints() {
        kMovieReleaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieOriginalTitleLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupReleaseDataLabelConstraints() {
        movieReleaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(kMovieReleaseDateLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupKProductionCountriesLabelConstraints() {
        kMovieProductionCountriesLabel.snp.makeConstraints { make in
            make.top.equalTo(movieReleaseDateLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupProductionCountriesLabelConstraints() {
        movieProductionCountriesLabel.snp.makeConstraints { make in
            make.top.equalTo(kMovieProductionCountriesLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupKBudgetLabelConstraints() {
        kMovieBudgetLabel.snp.makeConstraints { make in
            make.top.equalTo(movieProductionCountriesLabel.snp_bottomMargin).offset(30)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setupBudgetLabelConstraints() {
        movieBudgetLabel.snp.makeConstraints { make in
            make.top.equalTo(kMovieBudgetLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview()
        }
    }
    
    @objc private func trailerButtonPressed() {
        presenter.tapOnTheTrailer()
    }
}

//MARK: - Extension -
//MARK: - MovieInfoViewProtocol -
extension MovieInfoViewController: MovieInfoViewProtocol {
    func setMovieInfo(_ model: MovieDetailsData) {
        self.hideSpinner(self.spinner)
        configure(with: model)
        
        if let poster = model.backdropPath {
            NetworkService.shared.setImage(imageURL: poster,
                                           imageView: self.moviePoster)
        } else {
            self.moviePoster.image = UIImage(systemName: "xmark.circle")
            self.moviePoster.tintColor = .black
        }
    }
    
    func configure(with model: MovieDetailsData) {
        var genresArray = ""
        for genre in model.genres {
            genresArray.addingDevidingPrefixIfNeeded()
            genresArray += genre.name.capitalizingFirstLetter()
        }
        
        var production = ""
        if model.productionCountries.isEmpty {
            production = "No Info"
        }  else {
            production = model.productionCountries[0].name
        }
        
        DispatchQueue.main.async {
            self.title = model.title
            self.movieRatingLabel.text = String(model.voteAverage)
            self.movieTitleLabel.text = model.title
            self.movieGenresLabel.text = genresArray
            self.movieOverviewLabel.text = model.overview
            self.movieOriginalTitleLabel.text = model.originalTitle
            self.movieReleaseDateLabel.text = model.releaseDate?.replace(target: "-",
                                                                         withString: ".")
            self.movieProductionCountriesLabel.text = production
            self.movieBudgetLabel.text = String(model.budget) + "₴"
        }
    }
    
    func playMovieVideo(with id: String) {
        print(id)
    }
    
    func showErrorAlert(with message: String) {
        showAlert("Error", with: message)
    }
}
