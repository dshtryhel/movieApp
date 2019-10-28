//
//  Movie.swift
//  MovieDBApp
//
//  Created by mac on 9/17/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

struct Movies: Codable {
    
    let results: [Movie]
    let totalPages: Int
    let page: Int
    
    private enum CodingKeys: String, CodingKey {
        case results, page
        case totalPages = "total_pages"
    }
}

struct Movie: Codable {
    
    let name: String?
    let id: Int
    let title: String?
    let overview: String?
    let posterImage: String?
    let backdropImage: String?
    let rating: Double?
    let release: String?
    let date: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, title, overview, id
        case posterImage = "poster_path"
        case backdropImage = "backdrop_path"
        case rating = "vote_average"
        case release = "release_date"
        case date = "first_air_date"
    }
}

extension Movie {
    
    func dateFormatter(string: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter.date(from: string)
    }
}

