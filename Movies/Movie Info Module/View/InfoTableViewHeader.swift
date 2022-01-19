//
//  InfoTableViewHeader.swift
//  Movies
//
//  Created by Данил Фролов on 19.01.2022.
//

import UIKit

class InfoTableViewHeader: UITableViewHeaderFooterView {
    static let identifier = "TableHeader"
    
    private lazy var movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24,
                                 weight: .bold)
        label.numberOfLines = 0
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(movieTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        movieTitleLabel.sizeToFit()
        setupMovieTitleLabelConstraints()
    }
    
    func configure(title: String) {
        movieTitleLabel.text = title
    }
    
    private func setupMovieTitleLabelConstraints() {
        movieTitleLabel.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview().inset(25)
            make.left.right.equalToSuperview().inset(20)
        }
    }
}
