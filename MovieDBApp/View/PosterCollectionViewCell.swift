//
//  MovieCollectionViewCell.swift
//  MovieDBApp
//
//  Created by mac on 9/16/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private properties
    
    @IBOutlet private weak var posterImageView: UIImageView!
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public methods
    
    func setup(with viewModel: MovieCellViewModel) {
        
        if let string = viewModel.posterImage, viewModel.posterImage != "noImage" {
            HomeViewController.viewModel.downloadImage (for: string, { [weak self] image in
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            })
        } else {
            self.posterImageView.image = UIImage(named: "noImage")
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
    }
}
