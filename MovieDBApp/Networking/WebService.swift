//
//  APIService.swift
//  MovieDBApp
//
//  Created by mac on 9/16/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

protocol WebServicable: class {
    func fetchMovies(with action:String, type:String, query:String?, page:Int?,
                     completion: @escaping (Movies) -> ())
    func fetchMovieDetails(type: String, id: Int, completion: @escaping (MovieDetails) -> ())
    func fetchConfigurationImage(completion: @escaping (String) -> ())
    func downloadImage(from url: URL, completion: @escaping (UIImage?)->())
}

class WebService: WebServicable {

    // MARK: - Private properties
    
    private let scheme = "https"
    private let host = "api.themoviedb.org"
    private let path = "/3/%@/%@?&api_key=%@"
    private let keyAPI = "13ac51a17c16a264e63affb37446d9b0"
    
    private let urlSession = URLSession.shared
    private let cache = NSCache<NSString, UIImage>()
    
    // MARK: - Public methods
    
    func fetchMovies(with action:String, type:String, query:String?, page:Int?,
                     completion: @escaping(Movies) -> ()) {

        let path = String(format: self.path, action, type, keyAPI)
        
        var urlString = scheme +
                        "://" +
                        host +
                        path
        
        if query != nil {
            urlString += String("&query=\(query!))")
        }
        
        if page != nil {
            urlString += String("&page=\(page!)")
        }
        
        guard let url = URL(string: urlString) else { return }
        
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let movies = try JSONDecoder().decode(Movies.self, from: data)
                completion(movies)
            } catch let jsonError {
                print("Error serialization JSON:", jsonError)
            }
            }.resume()
    }
    
    func fetchMovieDetails(type: String, id: Int, completion: @escaping(MovieDetails) -> ()) {
        
        let path = String(format: self.path, type, String(id), keyAPI)
        
        let urlString = scheme +
                        "://" +
                        host +
                        path
        
        guard let url = URL(string: urlString) else { return }
        
        urlSession.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                let details = try JSONDecoder().decode(MovieDetails.self, from: data)
                completion(details)
            } catch let jsonError {
                print("Error serialization JSON:", jsonError)
            }
            }.resume()
    }
    
    func fetchConfigurationImage(completion: @escaping (String) -> ()) {
        
        let urlString = scheme +
                        "://" +
                        host +
                        "/3/configuration?api_key=" +
                        keyAPI
        
        guard let url = URL(string: urlString) else { return }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let data = data {
                let stack = try! JSONDecoder().decode(Images.self, from: data)
                let partImageUrl = stack.images.baseUrl + stack.images.size[0]
                DispatchQueue.main.async {
                    completion(partImageUrl)
                }
            }
            }.resume()
    }
    
    func downloadImage(from url: URL, completion: @escaping (UIImage?) -> ()) {
        
        if let image = cache.object(forKey: url.absoluteString as NSString) {
                completion(image)
        } else {
            urlSession.dataTask(with: url) { data, response, error in
                var downloadedImage: UIImage?
                if let data = data {
                    downloadedImage = UIImage(data: data)
                }
                
                if downloadedImage != nil {
                    self.cache.setObject(downloadedImage!, forKey: url.absoluteString as NSString)
                }
                
                DispatchQueue.main.async {
                    completion(downloadedImage)
                }
                
                }.resume()
        }
    }
    
}
