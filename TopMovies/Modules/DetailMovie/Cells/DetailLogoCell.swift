//
//  DetailLogoCell.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import UIKit
import Nuke

class DetailLogoCell: UITableViewCell {
    
    @IBOutlet private weak var movieLogoImgView: UIImageView!
    @IBOutlet private weak var movieNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieNameLbl.text = ""
        self.movieLogoImgView.image = UIImage(named: kPlaceholderImageName)
    }
    
    func setup(listCellViewModel: ListMovieCellViewModel) {
        self.movieNameLbl.text = listCellViewModel.movieTitle
        if let movieImageUrl = listCellViewModel.movieImage {
            if let url = Config.getImageUrlAsUrl(imageId: movieImageUrl){
                Nuke.loadImage(with: url, into: movieLogoImgView)
            }
        }
        self.movieNameLbl.sizeToFit()
    }
}

