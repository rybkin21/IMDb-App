
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
        viewModel.loadFilms { [weak self] in
            self?.films = self?.viewModel.films ?? []
            self?.tableView.reloadData()
        }
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
