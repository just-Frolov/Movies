//
//  MoviesTableViewCell.swift
//  Movies
//
//  Created by Данил Фролов on 10.01.2022.
//

import Kingfisher
import SnapKit
import UIKit

class MoviesTableViewCell: BaseTableViewCell {
    //MARK: - UI Elements -
    private lazy var movieView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.addSubview(moviePoster)
        view.addSubview(titleAndReleaseDataInfoView)
        view.addSubview(genresAndRatingInfoView)
        return view
    }()
    
    private lazy var moviePoster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var titleAndReleaseDataInfoView: UIStackView = {
        let view = UIStackView()
        view.addSubview(movieTitleLabel)
        view.addSubview(movieReleaseDataLabel)
        return view
    }()
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemMint
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var movieReleaseDataLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var genresAndRatingInfoView: UIStackView = {
        let view = UIStackView()
        view.addSubview(movieGenresLabel)
        view.addSubview(movieRatingLabel)
        return view
    }()

    private lazy var movieGenresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var movieRatingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    //MARK: - Life Cycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    func configure(with model: Movie) {
        imageView?.image = nil
        movieTitleLabel.text = model.title
        movieReleaseDataLabel.text = model.releaseDate
        movieGenresLabel.text = "\(model.genreIDS)"
        movieRatingLabel.text = String(model.voteAverage)
    }
    
    //MARK: - Private -
    private func addSubview() {
        contentView.addSubview(movieView)
    }
    
    private func setupConstraints() {
        setupMovieViewConstraints()
        setupMoviePosterConstraints()
        setupTitleAndReleaseDataInfoViewConstraints()
        setupMovieTitleLabelConstraints()
        setupMovieReleaseDataLabelConstraints()
    }
    
    private func setupMovieViewConstraints() {
        let marginFromEdges = CGFloat(10)
        movieView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView).inset(UIEdgeInsets(top: marginFromEdges,
                                                               left: marginFromEdges,
                                                               bottom: marginFromEdges,
                                                               right: marginFromEdges))
        }
    }
    
    private func setupMoviePosterConstraints() {
        moviePoster.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(movieView).inset(UIEdgeInsets(top: 25,
                                                               left: 5,
                                                               bottom: 25,
                                                               right: 5))
        }
    }
    
    private func setupTitleAndReleaseDataInfoViewConstraints() {
        titleAndReleaseDataInfoView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(movieView).inset(UIEdgeInsets(top: 5,
                                                               left: 5,
                                                               bottom: 75,
                                                               right: 5))
        }
    }
    
    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.bottom.equalTo(titleAndReleaseDataInfoView)
            make.width.equalTo(titleAndReleaseDataInfoView).dividedBy(2)
        }
    }
    
    private func setupMovieReleaseDataLabelConstraints() {
        movieReleaseDataLabel.snp.makeConstraints { (make) -> Void in
            make.right.top.bottom.equalTo(titleAndReleaseDataInfoView)
            make.width.equalTo(titleAndReleaseDataInfoView).dividedBy(2)
        }
    }
    
    private func setupGenresAndRatingInfoViewConstraints() {
        genresAndRatingInfoView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(movieView).inset(UIEdgeInsets(top: 75,
                                                               left: 5,
                                                               bottom: 5,
                                                               right: 5))
        }
    }
    
    private func setupMovieGenresLabelConstraints() {
        movieGenresLabel.snp.makeConstraints { (make) -> Void in
            make.left.top.bottom.equalTo(titleAndReleaseDataInfoView)
            make.width.equalTo(titleAndReleaseDataInfoView).dividedBy(2)
        }
    }
    
    private func setupMovieRatingLabelConstraints() {
        movieRatingLabel.snp.makeConstraints { (make) -> Void in
            make.right.top.bottom.equalTo(titleAndReleaseDataInfoView)
            make.width.equalTo(titleAndReleaseDataInfoView).dividedBy(2)
        }
    }
}

