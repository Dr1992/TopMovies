//
//  ListMovieViewModel.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import Foundation
import UIKit

typealias FectchMoviesCompletion = (_ success: Bool, _ error: Error?) -> Void

class ListMovieViewModel {
    private static let pageSize = 20
    
    private var movies: Movies?
    private var filteredMovies: [Result] = []
    private var currentPage = -1
    private var lastPage = -1
    private var fectchMoviesCompletion: FectchMoviesCompletion?
    var selectedMovieId: Int?
    
    var client: ClientServiceProtocol
    
    init(client: ClientServiceProtocol = Client()) {
        self.client = client
    }
    
    func fechMovies(isRefresh: Bool, _ completionBlock: @escaping FectchMoviesCompletion) {
        fectchMoviesCompletion = completionBlock
        self.loadNextPageIfNeeded(isRefresh: isRefresh, index: 0)
    }
    
    func getMoviesCount(isFiltering: Bool) -> Int {
        guard let count = movies?.results.count else {
            return 0
        }
        if isFiltering {
            return filteredMovies.count
        }
        return count
    }
    
    func setMovieIdSelected(at index: Int, isFiltering: Bool) {
        guard index >= 0 && index < getMoviesCount(isFiltering: isFiltering) else { return }
        
        if isFiltering {
            self.selectedMovieId = filteredMovies[index].id
        }
        else {
            self.selectedMovieId = movies?.results[index].id
        }
    }
    
    func movieInfo(at index: Int, isFiltering: Bool) -> ListMovieCellViewModel? {
        guard index >= 0 && index < getMoviesCount(isFiltering: isFiltering) else { return nil }
        
        if isFiltering {
            let listCell = ListMovieCellViewModel(movieTitle: self.filteredMovies[index].originalTitle, movieImage: self.filteredMovies[index].posterPath)
            return listCell
        }
        
        let listCell = ListMovieCellViewModel(movieTitle: movies?.results[index].originalTitle, movieImage: movies?.results[index].posterPath)
        self.loadNextPageIfNeeded(isRefresh: false, index: index)
        return listCell
    }
    
    
    func movieId(at index: Int, isFiltering: Bool) -> Int? {
        guard index >= 0 && index < getMoviesCount(isFiltering: isFiltering) else { return nil }
        
        if isFiltering {
            return self.filteredMovies[index].id
        }
        return movies?.results[index].id
    }
    
    func loadNextPageIfNeeded(isRefresh: Bool, index: Int) {
        
        if !isRefresh {
            let targetCount = currentPage < 0 ? 0 : (currentPage + 1) * ListMovieViewModel.pageSize - 1
            guard index == targetCount else {
                return
            }
            currentPage += 1
        }
        else {
            currentPage = 0
            self.movies = nil
        }
        let id = currentPage + 1
        
        self.fetchMovies(id: id)
    }
    
    private func fetchMovies(id: Int) {
        self.client.moviesRequest(pageNumber: id) { (response) in
            
            switch response {
            case .Success(let movies):
                if let _ = self.movies {
                    self.movies?.results.append(contentsOf: movies.results)
                } else {
                    self.movies = movies
                }
                CoreDataManager().addOrUpdateMovies(movies: movies)
                self.fectchMoviesCompletion?(true, nil)
            case .Error(_):
                self.fectchMoviesCompletion?(false, nil)
            }
        }
    }
    
    func filterContent(text: String) {
        if let results = self.movies?.results {
            self.filteredMovies = results.filter({( result : Result) -> Bool in
                if text == "" {
                    return true
                }
                if let originalTitle = result.originalTitle {
                    return originalTitle.lowercased().contains(text.lowercased())
                }
                return false
            })
        }
    }
}
