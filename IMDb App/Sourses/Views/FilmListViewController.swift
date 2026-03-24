
import UIKit
import SnapKit
import Kingfisher

final class FilmListViewController: UIViewController {

    // MARK: - Outlets

    private let viewModel: FilmListViewModelProtocol
    private var films: [Film] = []

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilmCell.self, forCellReuseIdentifier: FilmCell.reuseId)
        tableView.rowHeight = 120
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Init

    init(viewModel: FilmListViewModelProtocol) {
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
        setupLayout()
        loadData()
    }

    // MARK: - Setup

    private func setupHierarchy() {
        title = "Popular Films"
        view.backgroundColor = .systemMint
        view.addSubviews(tableView)
    }

    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func loadData() {
        // Показываем лоадер
        tableView.tableFooterView = createSpinnerFooter()

        viewModel.loadFilms { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }

                self.films = self.viewModel.films
                self.tableView.tableFooterView = nil

                if self.films.isEmpty {
                    if let errorMsg = self.viewModel.errorMessage {
                        self.showErrorAlert(message: errorMsg)
                    } else {
                        self.showEmptyState()
                    }
                }

                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Helper methods

    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 80))
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .systemBlue
        spinner.center = CGPoint(x: footerView.frame.width/2, y: 40)
        spinner.startAnimating()
        footerView.addSubview(spinner)
        return footerView
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.loadData()
        })
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        present(alert, animated: true)
    }

    private func showEmptyState() {
        let label = UILabel()
        label.text = "Фильмы не найдены"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        tableView.backgroundView = label
    }
}

// MARK: - Extension

extension FilmListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        films.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilmCell.reuseId, for: indexPath) as? FilmCell else {
            return UITableViewCell()
        }

        let film = films[indexPath.row]
        cell.configure(with: film)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectFilm(at: indexPath.row)
    }
}
