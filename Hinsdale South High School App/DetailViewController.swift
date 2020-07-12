//
//  DetailViewController.swift
//  Hinsdale South High School App
//
//  Created by Namit Sambare on 12/19/15.
//  Copyright © 2015 Hornet App Development. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var teacher: Teacher?

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let teacher = teacher {
            let attributes = [NSAttributedStringKey.foregroundColor: UIColor.red,
                               NSAttributedStringKey.underlineStyle: 1,
                               NSAttributedStringKey.underlineColor: UIColor.red] as [NSAttributedStringKey : Any]
            navigationItem.title = teacher.firstName! + " " + teacher.lastName!
            if let email = teacher.email {
                if email == "" {
                    emailLabel.text = "Not available"
                } else {
                    let attributedString = NSMutableAttributedString(string: email, attributes: attributes)
                    emailLabel.attributedText = attributedString
                    emailLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openEmail(_:))))
                }
            }
            if let phone = teacher.phone {
                if phone == "" {
                    phoneLabel.text = "Not available"
                } else {
                    let attributedString = NSMutableAttributedString(string: phone, attributes: attributes)
                    phoneLabel.attributedText = attributedString
                    phoneLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callNumber(_:))))
                }
            }
            if let department = teacher.department {
                departmentLabel.text = department == "" ? "Not available" : department
            }
            if let url = teacher.url {
                if url == "" {
                    urlLabel.text = "Not available"
                } else {
                    let attributedString = NSMutableAttributedString(string: url, attributes: attributes)
                    urlLabel.attributedText = attributedString
                    urlLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openURL(_:))))
                }
            }
        }
    }

    @objc func openEmail(_ gestureRecognizer: UIGestureRecognizer) {
        let alert = UIAlertController(title: emailLabel.text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Email", style: .default) { action in
            if let url = URL(string: String(format: "mailto:%@", self.emailLabel.text!)) {
                UIApplication.shared.openURL(url)
            }
        })
        present(alert, animated: true, completion: nil)
    }

    @objc func callNumber(_ gestureRecognizer: UIGestureRecognizer) {
        let alert = UIAlertController(title: phoneLabel.text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Call", style: .default) { action in
            if let url = URL(string: String(format: "tel:%@", self.phoneLabel.text!)) {
                UIApplication.shared.openURL(url)
            }
        })
        present(alert, animated: true, completion: nil)
    }

    @objc func openURL(_ gestureRecognizer: UIGestureRecognizer) {
        let alert = UIAlertController(title: urlLabel.text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open", style: .default) { action in
            if let url = URL(string: String(format: "https://%@", self.urlLabel.text!)) {
                UIApplication.shared.openURL(url)
            }
        })
        present(alert, animated: true, completion: nil)
    }
}
