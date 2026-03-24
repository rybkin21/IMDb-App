//
//  FilmListCoordinator.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import UIKit

final class FilmListCoordinator {

    // MARK: - Properties

    private let navigationController: UINavigationController
    private let apiService: APIServiceProtocol

    // MARK: - Init

    init(navigationController: UINavigationController, apiService: APIServiceProtocol) {
        self.navigationController = navigationController
        self.apiService = apiService
    }

    @MainActor func start() {
        let viewModel = FilmListViewModel(apiService: apiService, coordinator: self)
        let viewController = FilmListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showFilmDetails(for film: Film) {
        let detailsCoordinator = FilmDetailsCoordinator(
            navigationController: navigationController,
            film: film,
            apiService: apiService
            )
        detailsCoordinator.start()
    }
}
