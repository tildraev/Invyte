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
        
        let blurEffect  = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        backgroundImage.addSubview(blurView)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if let user = FIRAuth.auth()?.currentUser{
            //loggedInAsLabel.text?.append(user.email!)
            loggedInAsLabel.text = "Logged in as: " + user.email!
        }
        else{
            loggedInAsLabel.text = "Not logged in"
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        FriendSystem.system.addEventObserver {
            self.tableView.reloadData()
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
        
        // Modify cell
        cell!.label.text = FriendSystem.system.eventsAcceptedList[indexPath.row].titleAndDescription
        
        
        cell!.setDescriptionButtonAction {
            self.presentAlertView(description: FriendSystem.system.eventsAcceptedList[indexPath.row].titleAndDescription)
        }
        
        cell!.acceptButton.isEnabled = false
        cell!.acceptButton.alpha = 0
        cell!.setAcceptButtonAction {
            FriendSystem.system.acceptEventRequest(FriendSystem.system.eventsAcceptedList[indexPath.row].creatorID, titleAndDescription: FriendSystem.system.eventsAcceptedList[indexPath.row].titleAndDescription)
        }
        
        cell!.declineButton.setTitle("Remove", for: UIControlState.normal)
        cell!.setDeclineButtonAction {
            FriendSystem.system.removeEvent(FriendSystem.system.eventsAcceptedList[indexPath.row].creatorID)
            print(FriendSystem.system.eventsAcceptedList.count)
//            cell!.label.text = "Removed"
//            cell!.label.textColor = UIColor.lightGray
            self.viewWillDisappear(false)
            self.viewDidLoad()
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
