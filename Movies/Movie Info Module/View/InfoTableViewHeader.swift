//
//  InfoTableViewHeader.swift
//  Movies
//
//  Created by Данил Фролов on 19.01.2022.
//

import UIKit

class InfoTableViewHeader: UITableViewHeaderFooterView {
    //MARK: - Static -
    static let identifier = "TableHeader"
    
    //MARK: - UI Elements -
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    //MARK: - Life Cycle -
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(movieTitleLabel)
        setupMovieTitleLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Internal -
    func configure(title: String) {
        movieTitleLabel.text = title
    }
    
    //MARK: - Private -
    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
