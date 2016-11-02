//
//  BackTableVC.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/1/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class BackTableVC: UITableViewController {
    
    var tableArray = [String]()
    
    
    override func viewDidLoad() {
        tableArray = ["Main Menu", "Create Event", "View Invytes", "Find Friends", "User Info", "Share & Rate", "Help", "Support Invyte", "View Friends", "Friend Requests"]
        self.view.backgroundColor = UIColor.black
        let imageView = UIImageView(image: #imageLiteral(resourceName: "GatsbyBackground"))
        self.tableView.backgroundView = imageView
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: tableArray[indexPath.row], for: indexPath)
        
        cell.textLabel?.text = tableArray[indexPath.row]
        
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.0)
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.font = UIFont.init(name: "Game of Thrones", size: 15.0)
        
        return cell
    }

}
