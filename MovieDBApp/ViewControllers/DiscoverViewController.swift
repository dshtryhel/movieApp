//
//  DiscoverViewController.swift
//  MovieDBApp
//
//  Created by mac on 9/16/19.
//  Copyright © 2019 Dean Shtryhel. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    // MARK: - Private properties
    
    @IBAction private func didTapMoviesButton(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("discover", forKey:"action")
        userDefaults.set("movie", forKey:"type")
        userDefaults.synchronize()
        if let tabBarController = self.parent?.parent as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    @IBAction private func didTapSerialsButton(_ sender: Any) {
        let userDefaults = UserDefaults.standard
        userDefaults.set("discover", forKey:"action")
        userDefaults.set("tv", forKey:"type")
        userDefaults.synchronize()
        if let tabBarController = self.parent?.parent as? UITabBarController {
            tabBarController.selectedIndex = 1
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
