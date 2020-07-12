//
//  LinksViewController.swift
//  Hinsdale South High School App
//
//  Created by Sagar Natekar on 10/31/15.
//  Copyright © 2015 Hornet App Development. All rights reserved.
//

import UIKit

class LinksViewController: UITableViewController {

    let links = ["http://hs.hinsdale86.org/site/default.aspx?PageID=11",
                 "https://login.microsoftonline.com/login.srf?wa=wsignin1.0&rpsnv=4&ct=1439833952&rver=6.6.6556.0&wp=MBI_SSL&wreply=https:%2F%2Foutlook.office365.com%2Fowa%2F%3Frealm%3Ddistrict86.mail.onmicrosoft.com&i",
                "http://hinsdale86.schoolwires.net/Page/408",
                "http://d86.hinsdale86.org/Page/12",
                "http://www.southstinger.com/",
                "http://d86.hinsdale86.org/Page/679",
                "https://mobile.twitter.com/HinsdaleSouthHS",
                "http://www.hinsdalesouthathletics.org/"]

    var selectedRow = -1
    var selectedRowTitle: String?
    let segueIdentifierWebView = "linkDisplaySegue"
    let segueIdentifierFinalsCalculator = "finalsCalcSegue"

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.clearBackButtonText()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectedRow = indexPath.row
        selectedRowTitle = tableView.cellForRow(at: indexPath)?.textLabel?.text
        if selectedRow != tableView.numberOfRows(inSection: 0) - 1 {
            performSegue(withIdentifier: segueIdentifierWebView, sender: self)
        } else {
            performSegue(withIdentifier: segueIdentifierFinalsCalculator, sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifierWebView {
            let displayVC = segue.destination as? LinkDisplayViewController
            displayVC?.url = links[selectedRow]
            displayVC?.navBarTitle = selectedRowTitle
        }
    }
}
