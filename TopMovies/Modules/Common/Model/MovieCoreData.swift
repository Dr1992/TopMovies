//
//  MovieCoreData.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import Foundation
import CoreData


class MovieCoreData {
    
    var id: Int?
    var originalTitle: String?
    var poster: Data?
    
    func parseData(data: NSManagedObject) {
        self.originalTitle = data.value(forKey: MovieValues.name.rawValue) as? String
        self.id = data.value(forKey: MovieValues.id.rawValue) as? Int
        self.poster =  data.value(forKey: MovieValues.posterImage.rawValue) as? Data
    }
}
