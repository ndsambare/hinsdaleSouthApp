//
//  HomepageViewController.swift
//  Hinsdale South High School App
//
//  Created by Namit Sambare on 7/21/15.
//  Copyright (c) 2015 Hornet App Development. All rights reserved.
//

import UIKit

class HomepageViewController: UIViewController {
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.layer.cornerRadius = 10.0
    }

    @IBAction func continueToTabBar(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

