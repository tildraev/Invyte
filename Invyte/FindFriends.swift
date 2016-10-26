//
//  FindFriends.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/3/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase

class FindFriends : UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var searchBarTextField: UITextField!
    var count = 0
    var usernameResults = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        let blurEffect  = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        backgroundImage.addSubview(blurView)
        self.view.backgroundColor = UIColor.black
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        FriendSystem.system.addUserObserver { () in
            self.tableView.reloadData()
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: AnyObject)
    {
        usernameResults.removeAll()
        count = 0
        tableView.reloadData()
        getResults()
    }
    
    func getResults()
    {
        var usernameEntered = ""
        if(self.searchBarTextField.text != "")
        {
            usernameEntered = self.searchBarTextField.text!
            //Search for the text entered as a username first, then as a first + last name.
            //If there are no results, display "no results found"
            //If there are results, append the UID of the results to the text field
            
            //If the username exists.
            self.ref.child("users").queryOrdered(byChild: "Username").queryEqual(toValue: usernameEntered).observe(.value, with: { (snapshot) in
                    if(snapshot.value is NSNull)
                    {
                        //No users with that username
                    }
                    else
                    {
                        //That username exists, append that result to the list!
                        //append to an array
                        if let snapDict = snapshot.value as? [String:AnyObject]{
                            for each in snapDict{
                                var result = ""
                                result.append(each.value["Username"] as! String)
                                self.usernameResults.append(result)
                            }
                            self.count = snapDict.count
                        }
                        self.tableView.reloadData()
                    }
                }, withCancel: { (error) in
                    print(error)
            })
            
            //If the name exists
            self.ref.child("users").queryOrdered(byChild: "Name").queryEqual(toValue: usernameEntered.lowercased()).observe(.value, with: { (secondSnapshot) in
                    if(secondSnapshot.value is NSNull)
                    {
                        //No users with that full name
                    }
                    else
                    {
                        if let snapDict = secondSnapshot.value as? [String:AnyObject]{
                            for each in snapDict{
                                var result = ""
                                result.append(each.value["Username"] as! String)
                                self.usernameResults.append(result)
                            }
                            self.count = snapDict.count
                        }
                        self.tableView.reloadData()
                    }
                }
            )
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        
        if cell == nil
        {
            tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        }
        
        cell!.label.alpha = 0
        cell?.leftButton.isEnabled = false
        cell!.leftButton.setTitle(usernameResults[indexPath.row], for: UIControlState.disabled)
        
//        cell!.rightButton.setTitle("Add", for: UIControlState.normal)
//        cell!.rightButton.isEnabled = true
        
        cell!.setRightButtonAction {
            var theirUID = ""
            self.ref.child("users").queryOrdered(byChild: "Username").queryEqual(toValue: self.usernameResults[indexPath.row]).observeSingleEvent(of: FIRDataEventType.childAdded, with: { (thirdSnapshot) in
                theirUID = thirdSnapshot.key
                FriendSystem.system.sendRequestToUser(theirUID)
                cell!.rightButton.isEnabled = false
                cell!.rightButton.setTitle("Request sent!", for: UIControlState.disabled)
            })
        }
        
        return cell!

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FriendSystem.system.removeUserObserver()
    }
}


