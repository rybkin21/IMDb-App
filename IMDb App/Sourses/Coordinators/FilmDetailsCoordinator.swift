//
//  FilmDetailsCoordinator.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import UIKit

final class FilmDetailsCoordinator {

    private let navigationController: UINavigationController
    private let film: Film
    private let apiService: APIServiceProtocol

    init(navigationController: UINavigationController, film: Film, apiService: APIServiceProtocol) {
        self.navigationController = navigationController
        self.film = film
        self.apiService = apiService
    }

    func start() {
        let viewModel = FilmDetailsViewModel(film: film, apiService: apiService)
        let viewController = FilmDetailsViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
