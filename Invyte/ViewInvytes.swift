//
//  ViewInvytes.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/3/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class ViewInvytes : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var backgroundImage: UIImageView!
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        self.tableview.reloadData()
        super.viewDidLoad()
        self.tableview.tableFooterView = UIView()
        tableview.delegate = self
        tableview.dataSource = self
        FriendSystem.system.addEventRequestObserver {
            self.tableview.reloadData()
        }
 
        self.view.backgroundColor = UIColor.black
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.eventList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell
        if cell == nil {
            tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell
        }
        
        // Modify cell
        cell!.label.text = FriendSystem.system.eventList[indexPath.row].titleAndDescription

        
        cell!.setDescriptionButtonAction {
            let descriptionToAlert = FriendSystem.system.eventList[indexPath.row].titleAndDescription
            FriendSystem.system.getUser(FriendSystem.system.eventList[indexPath.row].creatorID!, completion: { (user) in
                self.presentAlertView(description: descriptionToAlert!, title: user.username!.capitalized + " invytes you to:")
            })
        }
        
        cell!.setAcceptButtonAction {
            FriendSystem.system.acceptEventRequest(FriendSystem.system.eventList[indexPath.row].creatorID, titleAndDescription: FriendSystem.system.eventList[indexPath.row].titleAndDescription)
        }
        
        cell!.setDeclineButtonAction {
            FriendSystem.system.removeEventRequest(FriendSystem.system.eventList[indexPath.row].creatorID)
        }


        
        // Return cell
        return cell!
    }
    
    func presentAlertView(description: String, title: String) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FriendSystem.system.removeEventRequestObserver()
    }
}
