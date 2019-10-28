//
//  SerialViewController.swift
//  MovieDBApp
//
//  Created by mac on 9/18/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

class SerialsViewController: UIViewController {

    // MARK: - Private properties
    
    @IBOutlet weak var serialsCollectionView: UICollectionView!
    
    private let viewModel = SearchViewModel()
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.viewDidLoad()
        viewModel.fetchData(action: "discover", type: "tv", query: nil)
    }
    
}

extension SerialsViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SerialCell", for: indexPath) as? PosterCollectionViewCell else {
            return UICollectionViewCell()
        }

        guard let viewModel = viewModel.cellViewModel(for: indexPath.row) else {
            return UICollectionViewCell()
        }

        cell.setup(with: viewModel, type: "SerialsViewController")

        return cell
    }

}

extension SerialsViewController: SearchViewModelDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.serialsCollectionView.reloadData()
        }
    }
}
