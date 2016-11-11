//
//  Request.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/18/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import UIKit

class RequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        
        FriendSystem.system.addRequestObserver {
            self.tableView.reloadData()
        }
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.requestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        if cell == nil {
            tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        }
        
        // Modify cell
        cell!.label.text = FriendSystem.system.requestList[(indexPath as NSIndexPath).row].username
        cell!.leftButton.isEnabled = true
        cell!.rightButton.isEnabled = true
        cell!.rightButton.setTitle("Accept", for: UIControlState.normal)
        cell!.rightButton.setTitleColor(UIColor.green, for: UIControlState.normal)
        cell!.leftButton.isEnabled = true
        cell!.leftButton.setTitle("Decline", for: UIControlState.normal)
        cell!.leftButton.setTitleColor(UIColor.red, for: UIControlState.normal)
       
        
        cell!.setRightButtonAction {
            let id = FriendSystem.system.requestList[(indexPath as NSIndexPath).row].id
            FriendSystem.system.acceptFriendRequest(id!)
            cell!.rightButton.isEnabled = false
            cell!.leftButton.isEnabled = false
            cell!.leftButton.alpha = 0
            cell!.rightButton.setTitle("Accepted!", for: UIControlState.disabled)
        }
        
        cell!.setLeftButtonAction {
            let id = FriendSystem.system.requestList[(indexPath as NSIndexPath).row].id
            FriendSystem.system.rejectFriendRequest(id!)
            cell!.leftButton.isEnabled = false
            cell!.leftButton.setTitle("Declined!", for: UIControlState.disabled)
            cell!.rightButton.isEnabled = false
            cell!.rightButton.alpha = 0
        }
        
        // Return cell
        return cell!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FriendSystem.system.removeRequestObserver()
    }
    
}
