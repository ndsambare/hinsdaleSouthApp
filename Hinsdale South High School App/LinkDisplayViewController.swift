//
//  LinkDisplayViewController.swift
//  Hinsdale South High School App
//
//  Created by Sagar Natekar on 1/15/16.
//  Copyright © 2016 Hornet App Development. All rights reserved.
//

import UIKit

class LinkDisplayViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
        }
    }

    var url: String?
    var navBarTitle: String?
    fileprivate var activityIndicatorView: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        addSpinner()
        navigationItem.title = navBarTitle
        if let url = url, let loadableURL = URL(string: url) {
            webView.loadRequest(URLRequest(url: loadableURL))
        }
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

extension LinkDisplayViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicatorView?.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView?.stopAnimating()
    }
}
