//
//  MovieCellViewModel.swift
//  MovieDBApp
//
//  Created by mac on 9/17/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import Foundation

struct MovieCellViewModel {
    
    // MARK: - Public properties
    
    let name: String?
    let id: Int
    let description: String?
    let posterImage: String?
    let backdropImage: String?
    let rating: Double?
    let releaseYearString: String?
    
    // MARK: - Initializer
    
    init(movie: Movie) {
        
        name = movie.title ?? movie.name // In API, movie name has two variants - "title" and "name"
        
        id = movie.id
        
        if let description = movie.overview {
            if description.count == 0 {
                self.description = "Overview will be soon.."
            } else {
                self.description = description
            }
        } else {
            self.description = "Overview will be soon.."
        }
        
        rating = movie.rating
        
        if let posterImage = movie.posterImage {
            self.posterImage = posterImage
        } else {
            posterImage = "noImage"
        }
        
        if let backdropImage = movie.backdropImage {
            self.backdropImage = backdropImage
        } else {
            backdropImage = "noBackImage"
        }
        
        // In API, movie name has two variants - "release_date" and "first_air_date"
        let releaseDateString = movie.release ?? movie.date
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        let releaseDate: Date?
        
        if let releaseDateString = releaseDateString {
            releaseDate = movie.dateFormatter(string: releaseDateString)
        } else {
            releaseDate = nil
        }
        
        if let releaseDate = releaseDate {
            releaseYearString = formatter.string(from: releaseDate)
        } else {
            releaseYearString = nil
        }
    }
    
}


