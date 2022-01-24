//
//  InfoTableViewSection.swift
//  Movies
//
//  Created by Данил Фролов on 21.01.2022.
//

import Foundation
import UIKit

enum TableViewSectionType: String, CaseIterable {
    case genres = "Жанры"
    case description = "Описание"
    case rating = "Рейтинг IMBD"
    case originalTitle = "Оригинальное название"
    case releaseDate = "Дата релиза"
    case production = "Производство"
    case budget = "Бюджет"
    case revenue = "Доход"
}

class InfoTableViewSection: UITableViewHeaderFooterView {
    //MARK: - Static -
    static let identifier = "TableSection"
    
    //MARK: - UI Elements -
    private lazy var movieSectionHeader: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14,
                                 weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    
    //MARK: - Life Cycle -
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(movieSectionHeader)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    func configure(title: String) {
        movieSectionHeader.text = title
    }
    
    //MARK: - Private -
    private func setupConstraints() {
        setupMovieTitleLabelConstraints()
    }
    
    private func setupMovieTitleLabelConstraints() {
        movieSectionHeader.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
    }
}

