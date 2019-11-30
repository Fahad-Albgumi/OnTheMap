//
//  TableViewController.swift
//  OnTheMap
//
//  Created by fahad on 19/03/1441 AH.
//  Copyright © 1441 Fahad Albgumi. All rights reserved.
//

import UIKit

class TableViewController: ContainerViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tableView: UITableView!
    
    override var locationsData: LocationsData? {
        didSet {
            guard let locationsData = locationsData else { return }
            locations = locationsData.studentLocations
        }
    }
    var locations: [StudentLocation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        let student = locations[(indexPath as NSIndexPath).row]
        cell.name.text = "\(student.firstName!) \(student.lastName!)"
        cell.userUrl.text = "\(student.mediaURL!)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = locations[(indexPath as NSIndexPath).row]
        guard let url = URL(string: student.mediaURL ?? "") else {return}
        UIApplication.shared.open(url)
    }

}

