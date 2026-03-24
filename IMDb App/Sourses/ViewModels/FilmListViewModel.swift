//
//  FilmListViewModel.swift
//

import Foundation

protocol FilmListViewModelProtocol {
    var films: [Film] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }

    func loadFilms(completion: @escaping () -> Void)
    func didSelectFilm(at index: Int)
}

final class FilmListViewModel: FilmListViewModelProtocol {

    // MARK: - Properties
    private(set) var films: [Film] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String? = nil

    private let apiService: APIServiceProtocol
    private let coordinator: FilmListCoordinator

    init(apiService: APIServiceProtocol, coordinator: FilmListCoordinator) {
        self.apiService = apiService
        self.coordinator = coordinator
    }

    func loadFilms(completion: @escaping () -> Void) {
        isLoading = true
        errorMessage = nil

        apiService.fetchPopularFilms(page: 1) { [weak self] result in
            DispatchQueue.main.async { [weak self] in   // гарантируем главный поток
                guard let self = self else { return }

                self.isLoading = false

                switch result {
                case .success(let films):
                    self.films = films
                    completion()                    // вызываем только после обновления

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    print("Error downloads: \(error)")
                    completion()                    // всё равно вызываем, чтобы убрать лоадер
                }
            }
        }
    }

    func didSelectFilm(at index: Int) {
        guard index < films.count else { return }
        coordinator.showFilmDetails(for: films[index])
    }
}
