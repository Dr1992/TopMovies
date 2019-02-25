//
//  MovieOnlineDataSource.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import UIKit
import Nuke

protocol ListViewControllerProtocol {
    func isFiltering() -> Bool
}

class MovieOnlineDataSource: NSObject, UICollectionViewDataSource {
    
    private let listCellReuseIdentifier = "ListaCellIdentifier"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private let itemsPerRow: CGFloat = 3
    
    var viewModel: ListMovieViewModel = ListMovieViewModel()
    
    private var imagesCache = [IndexPath: UIImage]()
    private var delegate: ListViewControllerProtocol
    private var collectionView: UICollectionView
    
    init(collectionView: UICollectionView, delegate: ListViewControllerProtocol, viewModel: ListMovieViewModel) {
        self.delegate = delegate
        self.collectionView = collectionView
        self.viewModel = viewModel
        super.init()
        self.registerCells(collectionView: collectionView)
    }
    
    private func registerCells(collectionView: UICollectionView) {
        let nib = UINib(nibName: String(describing: ListMovieCell.self), bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: listCellReuseIdentifier)
    }
    
    func clearImageCache() {
        imagesCache = [IndexPath: UIImage]()
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
        
        if let listCellViewModel = self.viewModel.movieInfo(at: indexPath.row, isFiltering: self.delegate.isFiltering()) {
            cell.setup(listCellViewModel: listCellViewModel)
            if let imageCached = self.imagesCache[indexPath] {
                cell.movieLogoImgView.image = imageCached
            }
            else {
                if let movieImageUrl = listCellViewModel.movieImage {
                    
                    if let url = Config.getImageUrlAsUrl(imageId: movieImageUrl){
                        Nuke.loadImage(
                            with: url,
                            options: ImageLoadingOptions(
                                placeholder: UIImage(named: kPlaceholderImageName),
                                transition: .fadeIn(duration: 0.5)
                            ),
                            into: cell.movieLogoImgView,
                            completion: {
                                (_, _) in
                                self.imagesCache[indexPath] = cell.movieLogoImgView.image
                                CoreDataManager().addMovieImage(movieImage: cell.movieLogoImgView.image!, id: self.viewModel.movieId(at: indexPath.row, isFiltering: self.delegate.isFiltering()))
                        })
                    }
                }
            }
        }
        
        return cell
    }
}

extension MovieOnlineDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let _ = self.imagesCache[indexPath] {
                return
            }
            if let viewModel = viewModel.movieInfo(at: indexPath.row, isFiltering: self.delegate.isFiltering()){
                
                if let movieImageUrl = viewModel.movieImage {
                    if let url = Config.getImageUrlAsUrl(imageId: movieImageUrl){
                        
                        _ = ImagePipeline.shared.loadImage(
                            with: url,
                            progress: { response, _, _ in
                                self.imagesCache[indexPath] = response?.image
                        },
                            completion: { response, _ in
                                self.imagesCache[indexPath] = response?.image
                                
                        })
                    }
                }
            }
        }
    }
}
