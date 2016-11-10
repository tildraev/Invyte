//
//  FriendInviteList.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/18/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase
import OneSignal

class InviteList : UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()

        self.view.backgroundColor = UIColor.black
        
        tableView.delegate = self
        tableView.dataSource = self
        
        FriendSystem.system.addFriendObserver {
            self.tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        if cell == nil {
            tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        }
        
        // Modify cell
        cell!.label.alpha = 0
        cell!.leftButton.isEnabled = false
        cell!.leftButton.setTitle(FriendSystem.system.friendList[indexPath.row].username, for: UIControlState.disabled)
        cell!.rightButton.isEnabled = true
        cell!.rightButton.setTitle("Invyte", for: UIControlState.normal)
        
        var title = ""
        
        FriendSystem.system.CURRENT_USER_REF.child("Events").child(FriendSystem.system.CURRENT_USER_ID).observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            title = snapshot.value as! String
            
            }, withCancel: { (error) in
                print(error)
        })
        
        cell!.setRightButtonAction {
            FriendSystem.system.sendEventRequestToUser(userID: FriendSystem.system.friendList[indexPath.row].id, Event(creatorID: FriendSystem.system.CURRENT_USER_ID, eventTitleAndDescription: title))
            
            cell!.rightButton.isEnabled = false
            cell!.rightButton.setTitle("Invyted", for: UIControlState.disabled)
            
            
            OneSignal.postNotification(["contents": ["en": "You have a new Invyte!"], "include_player_ids": [FriendSystem.system.friendList[indexPath.row].oneSignalID]])
            
        }
        
        // Return cell
        return cell!
    }
    

    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reveal")
        self.present(vc!, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FriendSystem.system.removeFriendObserver()
    }
    
}
