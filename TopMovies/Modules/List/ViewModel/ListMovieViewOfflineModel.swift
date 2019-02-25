//
//  ListMovieViewOfflineModel.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import Foundation
import UIKit

class ListMovieViewOfflineModel {
    
    private var list: [MovieCoreData] = []
    private var filteredMovies: [MovieCoreData] = []
    var selectedMovieId: Int?
    
    init() {
        self.list = CoreDataManager().retrieveMovies()
    }
    
    
    func getMoviesCount(isFiltering: Bool) -> Int {
        if isFiltering {
            return filteredMovies.count
        }
        return list.count
    }
    
    func setMovieIdSelected(at index: Int, isFiltering: Bool) {
        guard index >= 0 && index < getMoviesCount(isFiltering: isFiltering) else { return }
        
        if isFiltering {
            self.selectedMovieId = list[index].id
        }
        else {
            self.selectedMovieId =  filteredMovies[index].id
        }
    }
    
    func movieInfo(at index: Int, isFiltering: Bool) -> ListMovieCellViewModel? {
        guard index >= 0 && index < getMoviesCount(isFiltering: isFiltering) else { return nil }
        
        if isFiltering {
            let listCell = ListMovieCellViewModel(movieTitle: self.filteredMovies[index].originalTitle, movieImage: nil)
            return listCell
        }
        
        let listCell = ListMovieCellViewModel(movieTitle: list[index].originalTitle, movieImage:nil)
        return listCell
    }
    
    func movieImage(at index: Int, isFiltering: Bool) -> UIImage? {
        guard index >= 0 && index < getMoviesCount(isFiltering: isFiltering) else { return nil }
        
        if isFiltering {
            return parseImage(data: self.filteredMovies[index].poster)
        }
        return parseImage(data: list[index].poster)
    }
    
    private func parseImage(data: Data?) -> UIImage?{
        if let data = data {
            if let image = UIImage(data: data) {
                return image
            }
        }
        return UIImage(named: kPlaceholderImageName)
    }
    
    func filterContent(text: String) {
        
        self.filteredMovies = list.filter({( result : MovieCoreData) -> Bool in
            
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

