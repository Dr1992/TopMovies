//
//  ListMovieViewController.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import UIKit

class ListMovieViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    private let presentDetailSegueIdentifier = "PresentDetailSegueIdentifier"
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let refreshControl = UIRefreshControl()
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    fileprivate let itemsPerRow: CGFloat = 3
    
    private var isOffline: Bool = false
    
    var viewModel: ListMovieViewModel = ListMovieViewModel()
    
    private var dataSource: MovieOnlineDataSource?
    private var dataSourceOffline: MovieOfflineDataSource?
    
    // MARK:View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchController()
        
        if Reachability.isConnectedToNetwork() {
            self.setup()
            self.fetchMovies()
        }
        else {
            self.alert(message: "You are offline, retrieving data from CoreData", title: "Warning")
            self.refreshControl.removeFromSuperview()
            self.setupDataSourceOffline()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: SetupMethods
    
    private func setup() {
        self.setupRefreshControl()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.searchBar.tintColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupRefreshControl() {
        listCollectionView.addSubview(refreshControl)
        refreshControl.tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Movies ...", attributes: nil)
        refreshControl.addTarget(self, action:
            #selector(ListMovieViewController.handleRefresh(_:)),
                                 for: .valueChanged)
    }
    
    private func setupDataSource() {
        self.dataSource = MovieOnlineDataSource(collectionView: self.listCollectionView, delegate: self, viewModel: self.viewModel)
        self.listCollectionView.dataSource = dataSource
        self.listCollectionView.delegate = self
        self.listCollectionView.prefetchDataSource = dataSource
        
        DispatchQueue.main.async {
            self.listCollectionView?.reloadData()
        }
    }
    
    private func setupDataSourceOffline() {
        
        self.isOffline = true
        self.dataSourceOffline = MovieOfflineDataSource(collectionView: self.listCollectionView, delegate: self)
        self.listCollectionView.dataSource = dataSourceOffline
        self.listCollectionView.delegate = self
        self.listCollectionView.prefetchDataSource = nil
        self.listCollectionView?.reloadData()
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.fetchMovies(isRefresh: true)
    }
    
    // MARK: ViewModel Services
    
    private func fetchMovies(isRefresh: Bool = false) {
        viewModel.fechMovies(isRefresh: isRefresh) { (success, error) in
            if !success {
                self.alert(message: "unable to retrieve movies, network failure, retrieving data from CoreData", title: "Warning")
                self.setupDataSourceOffline()
                self.refreshControl.removeFromSuperview()
            }
            else {
                self.setupDataSource()
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if isOffline {
            self.dataSourceOffline?.filterContent(text: searchText)
        }
        else {
            self.viewModel.filterContent(text: searchText)
        }
        listCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == presentDetailSegueIdentifier {
            if let vc = segue.destination as? DetailViewController, let movieId = viewModel.selectedMovieId  {
                vc.setMovieId(id: movieId)
            }
        }
    }
}

extension ListMovieViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if !Reachability.isConnectedToNetwork() {
            self.alert(message: "unable to retrieve movie details, verify your network connection and try again later.", title: "warning")
            return
        }
        self.viewModel.setMovieIdSelected(at: indexPath.row, isFiltering: self.isFiltering())
        self.performSegue(withIdentifier: presentDetailSegueIdentifier, sender: self)
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension ListMovieViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}


// MARK: UISearchBarDelegate

extension ListMovieViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
}

// MARK: UISearchResultsUpdating

extension ListMovieViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        self.dataSource?.clearImageCache()
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK: ListViewControllerProtocol

extension ListMovieViewController: ListViewControllerProtocol {
    
    func isFiltering() -> Bool {
        return searchController.isActive
    }
}

