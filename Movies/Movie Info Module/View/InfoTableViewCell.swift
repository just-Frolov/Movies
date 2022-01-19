//
//  InfoTableViewCell.swift
//  Movies
//
//  Created by Данил Фролов on 17.01.2022.
//

import SnapKit

enum TableViewCellType: String, CaseIterable {
    case genres = "Жанр"
    case description = "Описание"
    case rating = "Рейтинг IMBD"
    case originalTitle = "Оригинальное название"
    case releaseDate = "Дата релиза"
    case production = "Производство"
    case budget = "Бюджет"
}

class InfoTableViewCell: BaseTableViewCell {
    //MARK: - UI Elements -
    private lazy var staticMovieHeaderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var movieInfoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    //MARK: - Life Cycle -
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    func configure(header: String, text: String) {
        staticMovieHeaderLabel.text = header
        movieInfoLabel.text = text
    }
    
    //MARK: - Private -
    private func addSubviews() {
        contentView.addSubview(staticMovieHeaderLabel)
        contentView.addSubview(movieInfoLabel)
    }
    
    private func setupConstraints() {
        setupStaticMovieHeaderLabel()
        setupMovieInfoLabel()
    }
    
    private func setupStaticMovieHeaderLabel() {
        staticMovieHeaderLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
    
    private func setupMovieInfoLabel() {
        movieInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(staticMovieHeaderLabel.snp_bottomMargin).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
    }
}
