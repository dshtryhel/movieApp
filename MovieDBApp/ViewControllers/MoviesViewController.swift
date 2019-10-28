//
//  MoviesViewController.swift
//  MovieDBApp
//
//  Created by mac on 9/18/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {

    // MARK: - Private properties
    
    @IBOutlet private weak var moviesCollectionView: UICollectionView!
    
    private let viewModel = SearchViewModel()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.viewDidLoad()
        viewModel.fetchData(action: "discover", type: "movie", query: nil)
    }
    
}

extension MoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let viewModel = viewModel.cellViewModel(for: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        cell.setup(with: viewModel, type: "MoviesViewController")
        
        return cell
    }
    
}

extension MoviesViewController: SearchViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.moviesCollectionView.reloadData()
        }
    }
}
