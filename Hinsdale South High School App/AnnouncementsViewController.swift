//
//  CalendarViewController.swift
//  Hinsdale South High School App
//
//  Created by Namit Sambare on 12/29/15.
//  Copyright © 2015 Hornet App Development. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView! {
        didSet {
            webView.delegate = self
        }
    }

    fileprivate var activityIndicatorView: UIActivityIndicatorView?
    let announcementsURL = URL(string: "http://hs.hinsdale86.org/cms/lib010/IL01904717/Centricity/Domain/9/Daily_Announcements.pdf")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addSpinner()
        webView.loadRequest(URLRequest(url: announcementsURL!))
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

extension AnnouncementsViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicatorView?.startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView?.stopAnimating()
    }
}
