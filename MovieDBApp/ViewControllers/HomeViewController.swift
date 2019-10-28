//
//  SearchViewController.swift
//  MovieDBApp
//
//  Created by mac on 9/16/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - Private properties
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var moviesSearchBar: UISearchBar!
    
    static let viewModel = HomeViewModel(service: WebService())
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        HomeViewController.viewModel.homeDelegate = self
        HomeViewController.viewModel.viewDidLoad()
        HomeViewController.viewModel.getMainPage()
    }
    
    func segueToMovie(by index: Int) {
        
        let moviesScreen: MovieViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieViewController") as! MovieViewController
        
        moviesScreen.backdropImage = HomeViewController.viewModel.cellViewModel(for: index)?.backdropImage
        moviesScreen.posterImage = HomeViewController.viewModel.cellViewModel(for: index)?.posterImage
        moviesScreen.overview = HomeViewController.viewModel.cellViewModel(for: index)?.description
        moviesScreen.name = HomeViewController.viewModel.cellViewModel(for: index)?.name
        moviesScreen.rating = HomeViewController.viewModel.cellViewModel(for: index)?.rating
        moviesScreen.release = HomeViewController.viewModel.cellViewModel(for: index)?.releaseYearString

        self.navigationController?.pushViewController(moviesScreen, animated: true)
    }
    
}

extension HomeViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeViewController.viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let viewModel = HomeViewController.viewModel.cellViewModel(for: indexPath.row) else {
            return UICollectionViewCell()
        }
        
        cell.setup(with: viewModel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        segueToMovie(by: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastMovie = HomeViewController.viewModel.numberOfRows() - 1
        if indexPath.row == lastMovie {
            HomeViewController.viewModel.loadNextPage(type: HomeViewController.viewModel.type, searchText: HomeViewController.viewModel.searchText ?? "")
        }
    }
    
}

extension HomeViewController: HomeViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsScopeBar = false
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.showsScopeBar = true
        searchBar.setShowsCancelButton(true, animated: true)
        HomeViewController.viewModel.searchTextDidChange(searchBar: searchBar, text: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        HomeViewController.viewModel.searchTextDidChange(searchBar: searchBar, text: searchBar.text)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


