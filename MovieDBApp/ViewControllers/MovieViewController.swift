//
//  MovieViewController.swift
//  MovieDBApp
//
//  Created by mac on 9/18/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    // MARK: - Public properties
    
    var backdropImage: String?
    var posterImage: String?
    var overview: String?
    var rating: Double!
    var name: String?
    var release: String?
    
    // MARK: - Private properties
    
    private let viewModel = HomeViewModel(service: WebService())
    
    @IBOutlet private weak var secondGenreLabel: UILabel!
    @IBOutlet private weak var firstGenreLabel: UILabel!
    @IBOutlet private weak var voteRatingLabel: UILabel!
    @IBOutlet private weak var backdropImageView: UIImageView!
    @IBOutlet private weak var postImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var overviewText: UILabel!
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overviewText.text = overview
        
        voteRatingLabel.text = String(rating)
        
        if let name = name, let release = release {
            titleLabel.text = name + " " + "(" + release + ")"
        } else if let name = name {
            titleLabel.text = name
        }
        
        if let string = backdropImage, backdropImage != "noBackImage" {
            viewModel.downloadImage(for: string) { [weak self] image in
                DispatchQueue.main.async {
                    self?.backdropImageView.image = image
                }
            }
        } else {
            backdropImageView.image = UIImage(named: "noBackImage")
        }
        
        if let string = posterImage, posterImage != "noImage" {
            viewModel.downloadImage(for: string) { [weak self] image in
                DispatchQueue.main.async {
                    self?.postImageView.image = image
                }
            }
        } else {
            postImageView.image = UIImage(named: "noImage")
        }
        
    }
    
}


