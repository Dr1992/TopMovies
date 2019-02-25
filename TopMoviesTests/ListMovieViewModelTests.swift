//
//  ListMovieViewModelTests.swift
//  TopMoviesTests
//
//  Created by Diego Ramos de Almeida on 24/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import XCTest

@testable import TopMovies

class ListMovieViewModelTests: XCTestCase {
    
    var viewModel : ListMovieViewModel!
    fileprivate var service : ServiceMock!
    
    override func setUp() {
        super.setUp()
        self.service = ServiceMock()
        self.viewModel = ListMovieViewModel(client: service)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
    
    func testErrorService() {
        
        service.shouldDisplaySuccess = false
        
        self.viewModel.fechMovies(isRefresh: false,{ (success, error) in
            XCTAssert(true, "ViewModel Should not Be able to return data")
            XCTAssertEqual(success, false, "success should be false")
        })
    }
    
    func testSuccessService() {
        
        service.shouldDisplaySuccess = true
        
        self.viewModel.fechMovies(isRefresh: false,{ (success, error) in
            XCTAssert(true, "ViewModel Should Be able to return")
            XCTAssertEqual(success, true, "success should be true")
        })
    }
    
    func testMovieCount() {
        
        testSuccessService()
        
        let movieCountFiltering = self.viewModel.getMoviesCount(isFiltering: true)
        XCTAssertEqual(movieCountFiltering, 0, "expect movie count equals to 0")
        
        let movieCountNoFiltering = self.viewModel.getMoviesCount(isFiltering: false)
        XCTAssertEqual(movieCountNoFiltering, 3, "expect movie count equals to 3")
    }
    
    func testFiltering() {
        
        testSuccessService()
        
        self.viewModel.filterContent(text: "Movie")
        XCTAssertEqual(self.viewModel.getMoviesCount(isFiltering: true), 3, "expect movie count when filtering equals to 3")
        
        self.viewModel.filterContent(text: "No Movies")
        XCTAssertEqual(self.viewModel.getMoviesCount(isFiltering: true), 0, "expect movie count when filtering equals to 0")
    }
    
    func testMovieIdSelected() {
        
        testSuccessService()
        
        self.viewModel.setMovieIdSelected(at: 0, isFiltering: false)
        XCTAssertEqual(self.viewModel.selectedMovieId, 1, "expect movie id selected to be equals to 1")
        
        self.viewModel.filterContent(text: "Movie 3")
        self.viewModel.setMovieIdSelected(at: 0, isFiltering: true)
        XCTAssertEqual(self.viewModel.selectedMovieId, 3, "expect movie id selected to be equals to 3")
        
    }
    
    func testMovieInfo() {
        
        testSuccessService()
        
        let movieInfo = self.viewModel.movieInfo(at: 0, isFiltering: false)
        XCTAssertEqual(movieInfo?.movieTitle, "Movie 1", "expect movie title to be equals to Movie 3")
        XCTAssertEqual(movieInfo?.movieImage, "101010.jpg", "expect movie image to be equals to 101010.jpg")
        
        self.viewModel.filterContent(text: "Movie 3")
        let movieInfoFiltered =  self.viewModel.movieInfo(at: 0, isFiltering: true)
        XCTAssertEqual(movieInfoFiltered?.movieTitle, "Movie 3", "expect movie title to be equals to Movie 3")
        XCTAssertEqual(movieInfoFiltered?.movieImage, "101010.jpg", "expect movie image to be equals to 101010.jpg")
    }
}



