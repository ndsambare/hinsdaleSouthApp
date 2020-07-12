//
//  ThirdViewControlller.swift
//  Hinsdale South High School App
//
//  Created by Namit Sambare on 7/28/15.
//  Copyright (c) 2015 Hornet App Development. All rights reserved.
//

import UIKit

class DirectoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView:UITableView! {
        didSet {
            tableView.addSubview(refreshControl)
            tableView.sectionIndexColor = UIColor.black
        }
    }

    fileprivate var teachers = [Teacher]()
    fileprivate var pageIndex: Int = 1
    fileprivate var maxPages = 15
    fileprivate let reuseIdentifier = "DirectoryCell"

    var sectionTitles = [String]()
    var names = [String:[Teacher]]()

    var baseURL = "http://hinsdale86.schoolwires.net/site/UserControls/Minibase/MinibaseListWrapper.aspx?ModuleInstanceID=523&DirectoryType=T&FilterFields=comparetype%3AE%3AS%3Bcomparetype%3AE%3AS%3B6%3AE%3ASouth%3B&"
    var pageIndexFormat = "PageIndex=%d"

    var activityIndicatorView: UIActivityIndicatorView?

    lazy var refreshControl: UIRefreshControl = {
        let aRefreshControl = UIRefreshControl()
        aRefreshControl.addTarget(self, action: #selector(refreshContentHandler), for: .valueChanged)

        return aRefreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let savedTeacherData = retrieveTeacherData() {
            teachers = savedTeacherData
            createNameSections()
            tableView.reloadData()
        } else {
            retrieveTeacherList()
            addSpinner()
        }

        navigationItem.clearBackButtonText()

        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    fileprivate func addSpinner() {
        activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: 100, height: 100)) as UIActivityIndicatorView
        if let activityIndicatorView = activityIndicatorView {
            activityIndicatorView.center = self.view.center
            activityIndicatorView.hidesWhenStopped = true
            activityIndicatorView.activityIndicatorViewStyle = .gray
            view.addSubview(activityIndicatorView)
            activityIndicatorView.startAnimating()
        }
    }

    @objc func refreshContentHandler() {
        refreshControl.beginRefreshing()
        retrieveTeacherList()
    }

    fileprivate func retrieveTeacherList() {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
            let semaphore = DispatchSemaphore(value: 0)

            let pageIndexString = String(format: self.pageIndexFormat, self.pageIndex)
            let urlString = self.baseURL + pageIndexString
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                    if let data = data {
                        let teachersParser = TFHpple(htmlData: data)

                        let XPathQueryString = "//div/table/tr[@class='sw-flex-row']"
                        let teacherNodes = teachersParser?.search(withXPathQuery: XPathQueryString) as! [TFHppleElement]

                        let altXPathQueryString = "//div/table/tr[@class='sw-flex-alt-Row']"
                        let altTeacherNodes = teachersParser?.search(withXPathQuery: altXPathQueryString) as! [TFHppleElement]

                        var elements = [TFHppleElement]()
                        var i = 0, j = 0

                        while(i < teacherNodes.count && j < altTeacherNodes.count) {
                            elements.append(teacherNodes[i])
                            i += 1
                            elements.append(altTeacherNodes[j])
                            j += 1
                        }

                        while(i < teacherNodes.count) {
                            elements.append(teacherNodes[i])
                            i += 1
                        }

                        while(j < altTeacherNodes.count) {
                            elements.append(altTeacherNodes[j])
                            j += 1
                        }

                        for element in elements {
                            let teacher = Teacher()

                            let components = element.content.components(separatedBy: "\n")
                            teacher.lastName = components[1].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                            teacher.firstName = components[2].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                            teacher.email = components[3].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                            teacher.phone = components[4].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                            teacher.url = components[5].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                            teacher.department = components[6].trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                            
                            self.teachers.append(teacher)
                        }
                        semaphore.signal()
                    }
                }) .resume()
            }

            semaphore.wait(timeout: DispatchTime.distantFuture)

            DispatchQueue.main.async {
                if self.pageIndex < self.maxPages {
                    self.pageIndex += 1
                    self.retrieveTeacherList()
                } else {
                    self.saveTeacherData()
                    self.activityIndicatorView?.stopAnimating()
                    self.refreshControl.endRefreshing()
                    self.createNameSections()
                    self.tableView.reloadData()
                }
            }
        }
    }

    fileprivate func createNameSections() {
        for teacher in teachers {
            let firstChar = String(teacher.lastName!.first!)
            if names[firstChar] == nil {
                names[firstChar] = []
                sectionTitles.append(firstChar)
            }
            names[firstChar]!.append(teacher)
        }
    }

    fileprivate func saveTeacherData() {
        NSKeyedArchiver.archiveRootObject(teachers, toFile: archiveFilePath())
    }

    fileprivate func retrieveTeacherData() -> [Teacher]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: archiveFilePath()) as? [Teacher]
    }

    fileprivate func archiveFilePath() -> String {
        let directoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return (directoryPath as NSString).appendingPathComponent("teachers.archive")
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        return names[sectionTitle]?.count ?? 0
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let sectionTitle = sectionTitles[indexPath.section]
        if let nameArray = names[sectionTitle] {
            let teacher = nameArray[indexPath.row]
            cell.textLabel?.text = teacher.lastName! + ", " + teacher.firstName!
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let sectionTitle = sectionTitles[indexPath.section]
            if let nameArray = names[sectionTitle] {
                let teacher = nameArray[indexPath.row]
                let detailVC = segue.destination as? DetailViewController
                detailVC?.teacher = teacher
            }
        }
    }
}
