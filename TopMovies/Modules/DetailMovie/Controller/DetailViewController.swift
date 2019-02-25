//
//  DetailViewController.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: DetailMovieDataSourceDelegate?
    var detailViewModel: DetailViewModel = DetailViewModel()
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationItem.backBarButtonItem?.title = ""
        loadingAlert()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.detailViewModel.fechMovieDetail { (success, error) in
            self.dismissLoadingAlert(with: {
                if success {
                    self.dataSource = DetailMovieDataSourceDelegate(tableView: self.tableView, detailViewModel: self.detailViewModel)
                    self.setupDataSource()
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: Setup
    
    private func setupDataSource(){
        self.tableView.dataSource = dataSource
        self.tableView.delegate = dataSource
        
    }
    func setMovieId(id: Int) {
        self.detailViewModel.movieId = id
    }
}
