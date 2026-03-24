//
//  FilmDetailsViewController.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import UIKit
import Kingfisher
import SnapKit

final class FilmDetailsViewController: UIViewController {

    // MARK: - Properties

    private var viewModel: FilmDetailsViewModelProtocol
    private var isDetailsLoaded = false

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var metadataStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var releaseDatelabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Overview"
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    // MARK: - Init

    init(viewModel: FilmDetailsViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupBindings()
        loadData()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        view.backgroundColor = .systemBackground
        scrollView.backgroundColor = .systemBackground
        contentView.backgroundColor = .systemBlue
        title = "Movie Details"

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews(
            posterImageView,
            titleLabel,
            metadataStack,
            genresLabel,
            overviewTitleLabel,
            overviewLabel,
            activityIndicator)

        metadataStack.addArrangedSubview(ratingLabel)
        metadataStack.addArrangedSubview(releaseDatelabel)
        metadataStack.addArrangedSubview(runtimeLabel)

        configureInitialState()
        setupLayout()
    }

    private func setupLayout() {

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }

        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(posterImageView.snp.width).multipliedBy(1.48)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(contentView).inset(20)
        }

        metadataStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.height.equalTo(24)
        }

        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(metadataStack.snp.bottom).offset(8)
            make.leading.trailing.equalTo(contentView).inset(20)
        }

        overviewTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(genresLabel.snp.bottom).offset(24)
            make.leading.trailing.equalTo(contentView).inset(20)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).offset(-20)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func setupBindings() {
        viewModel.onDetailsLoaded = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.isDetailsLoaded = true
                self?.configureWithDetails()
                self?.updateUI()
            }
        }

        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.showErrorAlert(message: error)
                self?.updateUI()
            }
        }
    }

    private func loadData() {
        activityIndicator.startAnimating()
        viewModel.loadFullFilmInfo()
    }

    private func updateUI() {
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    // MARK: - Configuration


    private func configureInitialState() {
        titleLabel.text = viewModel.film.title
        overviewLabel.text = "Loading..."

        if let posterPath = viewModel.film.posterPath,
           let url = Endpoints.filmPosterURL(path: posterPath) {
            posterImageView.kf.setImage(with: url)
        }
    }

    private func configureWithDetails() {
        guard let details = viewModel.filmDetails else {
            print("Film details are nil!")
            return
        }

        print("Loaded details:", details)

        UIView.animate(withDuration: 0.3) {
            self.ratingLabel.text = String(format: "⭐️ %.1f/10", details.voteAverage)
            self.releaseDatelabel.text = "📅 \(details.releaseDate)"

            self.runtimeLabel.text = details.runtime.map { "⏱ \($0) min" } ?? "⏱ N/A"

            if !details.genres.isEmpty {
                self.genresLabel.text = details.genres.map { $0.name }.joined(separator: " • ")
            } else {
                self.genresLabel.text = "No genres info"
            }

            self.overviewLabel.text = details.overview.isEmpty ? "No overview available" : details.overview
        }
    }


    // MARK: - Error Handling

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
