//
//  MainViewController.swift
//  Hinsdale South High School App
//
//  Created by Sagar Natekar on 2/7/16.
//  Copyright © 2016 Hornet App Development. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {
    var shouldShowHomePage = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false

        if UserDefaults.standard.bool(forKey: "firstLaunch") == false {
            shouldShowHomePage = true
            UserDefaults.standard.set(true, forKey: "firstLaunch")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if shouldShowHomePage {
            shouldShowHomePage = false

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "homepageViewController")
            present(vc, animated: true, completion: nil)
        }
    }
}
