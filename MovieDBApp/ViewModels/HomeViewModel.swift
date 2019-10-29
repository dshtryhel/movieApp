//
//  MoviesViewModel.swift
//  MovieDBApp
//
//  Created by mac on 9/17/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

protocol HomeViewModelDelegate: AnyObject {
    func reloadData()
}

class HomeViewModel {
    
    // MARK: - Public properties
    
    weak var homeDelegate: HomeViewModelDelegate?
    var details: MovieDetails?
    var searchText: String?
    var type = "movie"
    
    // MARK: - Private properties
    
    private var movies = [MovieCellViewModel]() {
        didSet {
            homeDelegate?.reloadData()
        }
    }
    private var timer: Timer?
    private var page: Int?
    private var totalPages: Int?
    private var fetchingMore = false
    private let webService: WebServicable
    
    // MARK: - Public properties
    
    // TO-DO: - Move to WebService
    static var urlConfiguration = String()
    
    init(service: WebServicable) {
        webService = service
    }
    
    // MARK: - Life cycle
    
    func viewDidLoad() {
        // TO-DO: - Move to WebService
        
        webService.fetchConfigurationImage { (imageUrl) -> () in

            HomeViewModel.urlConfiguration = imageUrl
        }
    }
    
    // MARK: - Public methods
    
    func downloadImage(for urlString: String, _ completion: @escaping (UIImage?)->()) {
        guard let url = URL(string: HomeViewModel.urlConfiguration + urlString) else { return }
        webService.downloadImage(from: url, completion: completion)
    }
    
    func numberOfRows() -> Int {
        return movies.count
    }
    
    func cellViewModel(for row: Int) -> MovieCellViewModel? {
        guard movies.count > row else {
            return nil
        }
        return movies[row]
    }
    
    func fetchData(action: String,
                   type: String,
                   query: String?,
                   page: Int?,
                   completion: (() -> Void)? = nil) {
        
        webService.fetchMovies(with: action, type: type, query: query, page: page, completion: {
            [weak self] movies in
            guard let self = self else {
                return
            }
            self.fetchingMore = false
            self.movies += movies.results.map({ MovieCellViewModel(movie: $0) })
            self.page = movies.page
            self.totalPages = movies.totalPages
        })
    }
    
    func fetchMovieDetails(type: String, id: Int) {
        
        webService.fetchMovieDetails(type: type, id: id, completion: {
                details -> () in
            
            self.details = details
        })
    }
    
    func loadNextPage(type: String, searchText: String) {
        if let page = page, let totalPages = totalPages {
            guard !fetchingMore, page + 1 <= totalPages else {
                return
            }
        }
        fetchingMore = true
        if let page = page {
            fetchData(action: "search",
                      type: type,
                      query: searchText,
                      page: page + 1)
        }
    }
    
    func resetResults() {
        movies = []
    }
    
    func searchTextDidChange(searchBar: UISearchBar, text: String?) {
        resetResults()
        searchText = text
        if searchText == nil {
            searchText = ""
        }
        let scopeTitles = ["movie", "tv"]
        self.type = scopeTitles[searchBar.selectedScopeButtonIndex]
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.fetchData(action: "search", type: self.type, query: self.searchText, page: nil)
        })
    }
    
    func getMainPage() {
        let userDefaults = UserDefaults.standard
        if let action = userDefaults.object(forKey: "action") as? String,
           let type = userDefaults.object(forKey: "type") as? String {
            resetResults()
            self.searchText = ""
            self.type = type
            fetchData(action: action, type: type, query: nil, page: nil)
            userDefaults.set(nil, forKey:"action")
            userDefaults.set(nil, forKey:"type")
        } else {
            resetResults()
            self.searchText = "marvel"
            self.type = "movie"
            fetchData(action: "search", type: type, query: searchText, page: nil)
        }
    }
    
}
