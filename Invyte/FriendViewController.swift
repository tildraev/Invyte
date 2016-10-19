//
//  Friends.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/18/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import UIKit

class FriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        FriendSystem.system.addFriendObserver {
            self.tableView.reloadData()
        }
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        if cell == nil {
            tableView.register(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "UserCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        }
        
        // Modify cell
        cell!.button.setTitle("Remove", for: UIControlState())
        cell!.emailLabel.text = FriendSystem.system.friendList[(indexPath as NSIndexPath).row].email
        
        cell!.setFunction {
            let id = FriendSystem.system.friendList[(indexPath as NSIndexPath).row].id
            FriendSystem.system.removeFriend(id!)
        }
        
        // Return cell
        return cell!
    }
    
}
