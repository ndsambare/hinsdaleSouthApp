//
//  GradesViewController.swift
//  Hinsdale South High School App
//
//  Created by Namit Sambare on 7/29/15.
//  Copyright (c) 2015 Hornet App Development. All rights reserved.
//


import UIKit

class GradesViewController: UIViewController {
    @IBOutlet weak var viewWeb: UIWebView! {
        didSet {
            viewWeb.delegate = self
        }
    }

    fileprivate var activityIndicatorView: UIActivityIndicatorView?
    let gradesURL = URL(string: "https://portal.hinsdale86.org/HomeAccess/Account/LogOn?ReturnUrl=%2fhomeaccess%2f")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addSpinner()
        viewWeb.loadRequest(URLRequest(url: gradesURL!))
    }

    fileprivate func addSpinner() {
        activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)) as UIActivityIndicatorView
        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.center = view.center
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.activityIndicatorViewStyle = .gray
            view.addSubview(activityIndicatorView)
        }
    }
}

extension GradesViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicatorView?.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView?.stopAnimating()
    }
}
