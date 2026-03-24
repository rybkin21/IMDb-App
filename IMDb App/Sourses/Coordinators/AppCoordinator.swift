//
//  AppCoordinator.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import UIKit

final class AppCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    @MainActor func start() {
        testAPIService()
        let apiService = APIService()
        let filmListCoordinator = FilmListCoordinator(
            navigationController: navigationController,
            apiService: apiService
        )
        filmListCoordinator.start()
    }

    private func testAPIService() {
        let apiService = APIService()
        apiService.fetchPopularFilms(page: 1) { result in
            switch result {
            case .success(let films):
                print("Complete download films: \(films.count)")
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
}

