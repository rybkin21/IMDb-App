//
//  FilmListViewModel.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import Foundation

protocol FilmListViewModelProtocol {
    var films: [Film] { get }
    func loadFilms(completion: @escaping () -> Void)
    func didSelectFilm(at index: Int)
}

final class FilmListViewModel: FilmListViewModelProtocol {

    // MARK: - Properties

    private let apiService: APIServiceProtocol
    private let coordinator: FilmListCoordinator

    var films: [Film] = []

    // MARK: - Init

    init(apiService: APIServiceProtocol, coordinator: FilmListCoordinator) {
        self.apiService = apiService
        self.coordinator = coordinator
    }

    // MARK: - Methods
    
    func loadFilms(completion: @escaping () -> Void) {
        apiService.fetchPopularFulms(page: 1) { [weak self] result in
            switch result {
            case .success(let films):
                self?.films = films
                completion()
            case .failure(let error):
                print("Error downloads: \(error)")
            }
        }
    }

    func didSelectFilm(at index: Int) {
        let selectedFilm = films[index]
        coordinator.showFilmDetails(for: selectedFilm)
    }
}
