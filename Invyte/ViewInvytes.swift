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
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        FriendSystem.system.addEventRequestObserver {
            self.tableview.reloadData()
        }
        
        let blurEffect  = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        backgroundImage.addSubview(blurView)
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
            self.presentAlertView(description: FriendSystem.system.eventList[indexPath.row].titleAndDescription)
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
    
    func presentAlertView(description: String) {
        let alertController = UIAlertController(title: nil, message: description, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FriendSystem.system.removeEventObserver()
    }
}
