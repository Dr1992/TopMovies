//
//  Response.swift
//  TopMovies
//
//  Created by Diego Ramos de Almeida on 22/02/19.
//  Copyright © 2019 Diego Ramos de Almeida. All rights reserved.
//

import Foundation

enum Response <T>{
    case Success(T)
    case Error(String)
}
