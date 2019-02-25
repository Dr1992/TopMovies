//
//  MovieOfflineDataSource.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import UIKit

class MovieOfflineDataSource: NSObject, UICollectionViewDataSource {
    
    private let listCellReuseIdentifier = "ListaCellIdentifier"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 3
    
    private var delegate: ListViewControllerProtocol
    private var collectionView: UICollectionView
    
    var viewModel: ListMovieViewOfflineModel = ListMovieViewOfflineModel()
    
    
    init(collectionView: UICollectionView, delegate: ListViewControllerProtocol) {
        self.collectionView = collectionView
        self.delegate = delegate
        super.init()
        self.registerCells(collectionView: collectionView)
    }
    
    private func registerCells(collectionView: UICollectionView) {
        let nib = UINib(nibName: String(describing: ListMovieCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: listCellReuseIdentifier)
    }
    
    func filterContent(text: String) {
        self.viewModel.filterContent(text: text)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getMoviesCount(isFiltering: delegate.isFiltering())
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: listCellReuseIdentifier,
                                                      for: indexPath) as! ListMovieCell
        
        if let listCellViewModel = viewModel.movieInfo(at: indexPath.row, isFiltering: delegate.isFiltering()) {
            cell.setup(listCellViewModel: listCellViewModel)
            if let movieImage = viewModel.movieImage(at: indexPath.row, isFiltering: delegate.isFiltering()) {
                cell.movieLogoImgView.image = movieImage
            } else {
                cell.movieLogoImgView.image = UIImage(named: kPlaceholderImageName)
            }
        }
        return cell
    }
    
}
