//
//  FilmDetailsViewModel.swift
//  IMDb App
//
//  Created by Ivan Rybkin on 18.07.2025.
//

import Foundation

protocol FilmDetailsViewModelProtocol {
    var film: Film { get }
    var filmDetails: FilmDetails? { get }
    var onDetailsLoaded: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }

    func loadFullFilmInfo()
}

final class FilmDetailsViewModel: FilmDetailsViewModelProtocol {

    let film: Film
    private let apiService: APIServiceProtocol
    private(set) var filmDetails: FilmDetails?

    var onDetailsLoaded: (() -> Void)?
    var onError: ((String) -> Void)?

    init(film: Film, apiService: APIServiceProtocol) {
        self.film = film
        self.apiService = apiService
    }

    func loadFullFilmInfo() {
        apiService.fetchFilmDetails(id: film.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.filmDetails = details
                    self?.onDetailsLoaded?()
                case .failure(let error):
                    self?.onError?(error.localizedDescription)
                }
            }
        }
    }
}

