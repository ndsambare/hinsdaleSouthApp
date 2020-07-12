//
//  UINavigationItemExtension.swift
//  Hinsdale South High School App
//
//  Created by Sagar Natekar on 1/3/16.
//  Copyright © 2016 Hornet App Development. All rights reserved.
//

import UIKit

extension UINavigationItem {
    func clearBackButtonText() {
        backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
