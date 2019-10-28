//
//  ImageConfiguration.swift
//  MovieDBApp
//
//  Created by mac on 9/23/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

struct Images: Codable {
    
    let images: Image
}

struct Image: Codable {
    
    let baseUrl: String
    let size: [String]
    
    private enum CodingKeys: String, CodingKey {
        
        case baseUrl = "secure_base_url"
        case size = "backdrop_sizes"
    }
}

