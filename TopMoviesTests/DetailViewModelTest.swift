//
//  DetailViewModelTests.swift
//  TopMoviesTests
//
//  Created by Diego Ramos de Almeida on 24/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//


import XCTest

@testable import TopMovies

class DetailViewModelTest: XCTestCase {
    
    var viewModel : DetailViewModel!
    fileprivate var service : ServiceMock!
    
    override func setUp() {
        super.setUp()
        self.service = ServiceMock()
        self.viewModel = DetailViewModel(client: service)
    }
    
    override func tearDown() {
        self.viewModel = nil
        self.service = nil
        super.tearDown()
    }
    
    func testErrorService() {
        
        service.shouldDisplaySuccess = false
        
        self.viewModel.fechMovieDetail { (success, error) in
            XCTAssert(true, "ViewModel Should not Be able to return data")
            XCTAssertEqual(success, false, "success should be false")
        }
        
    }
    
    func testSuccessService() {
        
        service.shouldDisplaySuccess = true
        
        self.viewModel.fechMovieDetail { (success, error) in
            XCTAssert(true, "ViewModel Should Be able to return data")
            XCTAssertEqual(success, true, "success should be true")
        }
    }
    
    func testNumberOfRows() {
        XCTAssertEqual(self.viewModel.numberOfRows(), 5, "expect numberOfRows should be 5")
    }
    
    func testInfoForRow() {
        
        service.shouldDisplaySuccess = true
        
        self.viewModel.fechMovieDetail { (success, error) in
            XCTAssert(true, "ViewModel Should Be able to return data")
            XCTAssertEqual(success, true, "success should be true")
        }
        
        let logoInfo = self.viewModel.logoInfo()
        XCTAssertEqual(logoInfo?.movieTitle, "Movie 1", "expect title should be Movie 1")
        XCTAssertEqual(logoInfo?.movieImage, "101010.jpg", "expect image should be 101010.jpg")
        
        var titleSubtitle = self.viewModel.info(for: 1)
        XCTAssertEqual(titleSubtitle.title, "Overview", "expect title should be Overview")
        XCTAssertEqual(titleSubtitle.subtitle, "Movie 1 overview", "expect subtitle should be Movie 1 overview")
        
        titleSubtitle = self.viewModel.info(for: 2)
        XCTAssertEqual(titleSubtitle.title, "Votes", "expect title should be Votes")
        XCTAssertEqual(titleSubtitle.subtitle, "1000", "expect subtitle should be 1000")
        
        titleSubtitle = self.viewModel.info(for: 3)
        XCTAssertEqual(titleSubtitle.title, "Average", "expect title should be Average")
        XCTAssertEqual(titleSubtitle.subtitle, "5.0", "expect subtitle should be 5.0")
        
        titleSubtitle = self.viewModel.info(for: 4)
        XCTAssertEqual(titleSubtitle.title, "Companies", "expect title should be Companies")
        XCTAssertEqual(titleSubtitle.subtitle, "", "expect title should be empty")
        
        titleSubtitle = self.viewModel.info(for: 5)
        XCTAssertEqual(titleSubtitle.title, "", "expect title should be empty")
        XCTAssertEqual(titleSubtitle.subtitle, "", "expect title should be empty")
    }
}


