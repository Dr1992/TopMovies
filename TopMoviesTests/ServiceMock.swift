//
//  ServiceMock.swift
//  TopMoviesTests
//
//  Created by Diego Ramos de Almeida on 24/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//


import Foundation
@testable import TopMovies


class ServiceMock: ClientServiceProtocol {
    
    var shouldDisplaySuccess: Bool = true
    
    func moviesRequest(pageNumber: Int, completion: @escaping (Response<Movies>) -> ()) {
        if shouldDisplaySuccess {
            completion(Response.Success(mockMovies()))
        }
        else {
            completion(Response.Error("Failed"))
        }
    }
    
    func detailMoviesRequest(movieID: Int, completion: @escaping (Response<MovieDetail>) -> ()) {
        
        if shouldDisplaySuccess {
            completion(Response.Success(mockMoviesDetails()))
        }
        else {
            completion(Response.Error("Failed"))
        }
        
    }
    
    func getImageRequest(imageId: String, completion: @escaping (Data?, Error?) -> ()) {
        if shouldDisplaySuccess {
            completion(mockImageData(), nil)
        }
        else {
            let errorTemp = NSError(domain:"", code:0, userInfo:nil)
            completion(nil, errorTemp)
        }
    }
    
    func mockMovies() -> Movies{
        
        
        let movie1 = Result(voteCount: 10, id: 1, video: false, voteAverage: 20.5, title: "Movie 1", popularity: 10.0, posterPath: "101010.jpg", originalLanguage: "English", originalTitle: "Movie 1", genreIDS: nil, backdropPath: "", adult: false, overview: "Movie 1 overview", releaseDate: "10/10/2010")
        
        let movie2 = Result(voteCount: 10, id: 2, video: false, voteAverage: 20.5, title: "Movie 2", popularity: 10.0, posterPath: "101010.jpg", originalLanguage: "English", originalTitle: "Movie 2", genreIDS: nil, backdropPath: "", adult: false, overview: "Movie 2 overview", releaseDate: "10/10/2010")
        
        let movie3 = Result(voteCount: 10, id: 3, video: false, voteAverage: 20.5, title: "Movie 3", popularity: 10.0, posterPath: "101010.jpg", originalLanguage: "English", originalTitle: "Movie 3", genreIDS: nil, backdropPath: "", adult: false, overview: "Movie 3 overview", releaseDate: "10/10/2010")
        
        var results: [Result] = []
        
        results.append(movie1)
        results.append(movie2)
        results.append(movie3)
        
        let movies: Movies = Movies(page: 0, totalResults: 10, totalPages: 1, results: results)
        
        return movies
    }
    
    func mockMoviesDetails() -> MovieDetail {
        
        let movieDetails: MovieDetail = MovieDetail(adult: false, backdropPath: nil, belongsToCollection: nil, budget: 1000, genres: [], homepage: "", id: 10, imdbID: "10", originalLanguage: "English", originalTitle: "Movie 1", overview: "Movie 1 overview", popularity: 1000, posterPath: "101010.jpg", productionCompanies: [], productionCountries: [], releaseDate: "10/10/2010", revenue: 100, runtime: 100, spokenLanguages: [], status: "", tagline: "", title: "Movie 1", video: false, voteAverage: 5.0, voteCount: 1000)
        
        return movieDetails
    }
    
    func mockImageData() -> Data {
        let data: Data = Data()
        return data
    }
}
