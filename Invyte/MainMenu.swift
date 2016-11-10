//
//  MainMenu.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/4/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase

class MainMenu : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var loggedInAsLabel: UILabel!
    
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self

        FriendSystem.system.addEventObserver {
            self.tableView.reloadData()
        }
        
        makeItLookPretty()
        
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }

    func makeItLookPretty()
    {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let user = FIRAuth.auth()?.currentUser{
            //loggedInAsLabel.text?.append(user.email!)
            loggedInAsLabel.text = "Logged in as: " + user.email!
        }
        else{
            loggedInAsLabel.text = "Not logged in"
        }
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
        
        cell!.descriptionButton.isEnabled = false
        cell!.descriptionButton.alpha = 0
        
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
    }
    
}
