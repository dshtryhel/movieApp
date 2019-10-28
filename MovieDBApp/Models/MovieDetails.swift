//
//  MovieGenres.swift
//  MovieDBApp
//
//  Created by mac on 10/11/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

struct MovieDetails: Codable {

    let genres: [Genres]
    let status: String
}

struct Genres: Codable {
    
    let name: String?
}
