//
//  MainMenu.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/4/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase
import OneSignal

class MainMenu : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loggedInAsLabel: UILabel!
    @IBOutlet weak var newFriendLabel: UILabel!
    @IBOutlet weak var newInvyteLabel: UILabel!
    var refreshControl = UIRefreshControl()
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OneSignal.idsAvailable({ (userId, pushToken) in
            FriendSystem.system.CURRENT_USER_REF.child("OneSignalID").setValue(userId!)
        })
        
        self.tableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(MainMenu.didRefreshList), for: UIControlEvents.valueChanged)
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self

        FriendSystem.system.addEventObserver {
            self.tableView.reloadData()
        }
        
        FriendSystem.system.addRequestObserver {
            self.tableView.reloadData()
        }
        
        FriendSystem.system.addEventRequestObserver {
            self.tableView.reloadData()
        }
        
        FriendSystem.system.addFriendObserver {
            
        }
        
        
        makeItLookPretty()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    func didRefreshList(){
        FriendSystem.system.removeEventObserver()
        FriendSystem.system.removeEventRequestObserver()
        FriendSystem.system.removeRequestObserver()
        FriendSystem.system.removeFriendObserver()
        
        self.viewDidLoad()
        self.refreshControl.endRefreshing()
    }
    
    func makeItLookPretty()
    {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let user = FIRAuth.auth()?.currentUser{
            loggedInAsLabel.text = "Logged in as: " + user.email!
        }
        else{
            loggedInAsLabel.text = "Not logged in"
        }
        
        if(FriendSystem.system.eventList.count > 0){
            newInvyteLabel.alpha = 1
        }
        else{
            newInvyteLabel.alpha = 0
        }
        
        if(FriendSystem.system.requestList.count > 0){
            newFriendLabel.alpha = 1
        }
        else{
            newFriendLabel.alpha = 0
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FriendSystem.system.eventsAcceptedList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell

        if cell == nil {
            tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as? EventCell
        }
        
        let creatorID = FriendSystem.system.eventsAcceptedList[indexPath.row].creatorID
        
        // Modify cell
        
        cell!.label.text = FriendSystem.system.eventsAcceptedList[indexPath.row].titleAndDescription
        cell!.label.textColor = UIColor.white
        cell!.label.alpha = 1
        
        cell!.descriptionButton.isEnabled = true
        cell!.descriptionButton.alpha = 0
        cell!.acceptButton.alpha = 1
        cell!.acceptButton.isEnabled = true
        
        cell!.declineButton.isEnabled = true
        cell!.declineButton.setTitle("Decline", for: UIControlState.normal
        )
        cell!.setDescriptionButtonAction {
            //
        }
        
        cell!.acceptButton.isEnabled = true
        cell!.acceptButton.alpha = 1
        cell!.acceptButton.setTitle("Details", for: UIControlState.normal)
        
        cell!.setAcceptButtonAction {
            let descriptionToAlert = FriendSystem.system.eventsAcceptedList[indexPath.row].titleAndDescription
            FriendSystem.system.getUser(FriendSystem.system.eventsAcceptedList[indexPath.row].creatorID!, completion: { (user) in
                self.presentAlertView(description: descriptionToAlert!, title: user.username!.capitalized + " invytes you to:")
            })
        }
        
        cell!.declineButton.setTitle("Remove", for: UIControlState.normal)
        cell!.setDeclineButtonAction {
            FriendSystem.system.removeEvent(creatorID!)
            FriendSystem.system.removeEventRequest(creatorID!)
            cell!.declineButton.isEnabled = false
            cell!.declineButton.setTitle("Removed", for: UIControlState.disabled)
            cell!.acceptButton.alpha = 0
            cell!.acceptButton.isEnabled = false
            for friend in FriendSystem.system.friendList{
                FriendSystem.system.USER_REF.child(friend.id).child("Event Requests").child(FriendSystem.system.CURRENT_USER_ID).removeValue()
            }
        }
        
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
        FriendSystem.system.removeEventObserver()
        FriendSystem.system.removeEventRequestObserver()
        FriendSystem.system.removeRequestObserver()
        FriendSystem.system.removeFriendObserver()
    }
    
}
