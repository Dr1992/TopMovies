//
//  ListMovieCell.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import UIKit

struct ListMovieCellViewModel {
    let movieTitle, movieImage: String?
}

class ListMovieCell: UICollectionViewCell {
    
    @IBOutlet weak var movieLogoImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieLogoImgView.image = UIImage(named: kPlaceholderImageName)
    }
    
    func setup(listCellViewModel: ListMovieCellViewModel) {
        self.titleLbl.text = listCellViewModel.movieTitle
    }
}
