//
//  ContainerViewController.swift
//  OnTheMap
//
//  Created by fahad on 19/03/1441 AH.
//  Copyright © 1441 Fahad Albgumi. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentLocations()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStudentLocations()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
    func loadStudentLocations() {
        Parser.test()
        print("LoadStudents is working")
    }
}
