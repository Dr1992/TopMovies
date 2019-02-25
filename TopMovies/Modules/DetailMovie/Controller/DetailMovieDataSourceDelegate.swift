//
//  DetailMovieDataSourceDelegate.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//


import UIKit

class DetailMovieDataSourceDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    var detailViewModel: DetailViewModel
    private let logoCellReuseIdentifier = "LogoCellReuseIdentifier"
    
    init(tableView: UITableView, detailViewModel: DetailViewModel) {
        self.detailViewModel = detailViewModel
        super.init()
        self.registerCells(tableView: tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: logoCellReuseIdentifier, for: indexPath) as! DetailLogoCell
            if let logoInfo = detailViewModel.logoInfo() {
                cell.setup(listCellViewModel: logoInfo)
            }
            return cell
        default:
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            let info = detailViewModel.info(for: indexPath.row)
            cell.textLabel?.text = info.title
            cell.detailTextLabel?.text = info.subtitle
            cell.detailTextLabel?.sizeToFit()
            cell.detailTextLabel?.numberOfLines = 0
            cell.textLabel?.sizeToFit()
            return cell
        }
    }
    
    // MARK: Setup
    
    private func registerCells(tableView: UITableView) {
        let nib = UINib(nibName: String(describing: DetailLogoCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: logoCellReuseIdentifier)
        
    }
}
