//
//  DetailViewModel.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import Foundation

struct titleSubtitleViewModel {
    let title, subtitle: String?
}

class DetailViewModel {
    
    private var movieDetail: MovieDetail?
    private var fetchMovieDetailCompletionBlock: FectchMoviesCompletion?
    var movieId: Int = 0
    var client: ClientServiceProtocol?
    
    init(client: ClientServiceProtocol = Client()) {
        self.client = client
    }
    
    func fechMovieDetail(_ completionBlock: @escaping FectchMoviesCompletion) {
        self.fetchMovieDetailCompletionBlock = completionBlock
        self.loadMovieDetail()
    }
    
    func numberOfRows() -> Int {
        return 5
    }
    
    func logoInfo() -> ListMovieCellViewModel? {
        guard let movieDetail = self.movieDetail else {
            return nil
        }
        let logoInfo = ListMovieCellViewModel(movieTitle: movieDetail.originalTitle, movieImage: movieDetail.posterPath)
        return logoInfo
    }
    
    func info(for row: Int) -> titleSubtitleViewModel {
        
        //return titleSubtitleViewModel(title: "UM", subtitle: "DOIS")
        switch row {
        case 1:
            return titleSubtitleViewModel(title: "Overview", subtitle: movieDetail?.overview)
        case 2:
            return titleSubtitleViewModel(title: "Votes", subtitle: String(movieDetail?.voteCount ?? 0))
        case 3:
            return titleSubtitleViewModel(title: "Average", subtitle: String(movieDetail?.voteAverage ?? 0))
        case 4:
            return titleSubtitleViewModel(title: "Companies", subtitle: movieDetail?.getProductionCompaniesAsString())
        default:
            return titleSubtitleViewModel(title: "", subtitle: "")
        }
    }
    
    private func loadMovieDetail() {
        
        self.client?.detailMoviesRequest(movieID: self.movieId) { (response) in
            
            switch response {
            case .Success(let movieDetail):
                self.movieDetail = movieDetail
                self.fetchMovieDetailCompletionBlock?(true, nil)
            case .Error(_):
                self.fetchMovieDetailCompletionBlock?(false, nil)
            }
        }
    }
}
