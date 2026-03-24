//
//  FilmCell.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import UIKit
import Kingfisher

final class FilmCell: UITableViewCell {
    static let reuseId = "FilmCell"

    // MARK: - UI Elements

    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupHierarchy() {
        contentView.addSubviews(
            posterImageView,
            titleLabel,
            overviewLabel
        )
    }

    private func setupLayout() {

        posterImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.bottom.equalToSuperview().inset(8)
            make.width.equalTo(80)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(posterImageView)
        }

        overviewLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }

    //MARK: - Configuration

    func configure(with film: Film) {
        titleLabel.text = film.title
        overviewLabel.text = film.overview

        if let posterPath = film.posterPath,
           let url = film.posterURL {
            posterImageView.kf.setImage(with: url)
        } else {
            posterImageView.image = UIImage(named: "placeholder")
        }
    }
}

