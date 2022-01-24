//
//  InfoTableViewCell.swift
//  Movies
//
//  Created by Данил Фролов on 17.01.2022.
//

import SnapKit

struct InfoTableSectionModel {
    let type: TableViewSectionType
    let cellTypes: [TableViewCellType]
}

enum TableViewCellType: CaseIterable {
    case genres
    case description 
    case rating 
    case originalTitle
    case releaseDate
    case production
    case budget
    case revenue
}

class InfoTableViewCell: BaseTableViewCell {
    //MARK: - UI Elements -
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
    func configure(with info: String) {
        movieInfoLabel.text = info
    }
    
    //MARK: - Private -
    private func addSubviews() {
        contentView.addSubview(movieInfoLabel)
    }
    
    private func setupConstraints() {
        setupMovieInfoLabel()
    }
    
    private func setupMovieInfoLabel() {
        movieInfoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
