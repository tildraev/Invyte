//
//  UserInfo.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/3/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase

class Replies : UIViewController, UITableViewDelegate, UITableViewDataSource{
    

    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doneButton.backgroundColor = UIColor.clear
        doneButton.layer.cornerRadius = 5
        doneButton.layer.borderWidth = 1
        doneButton.layer.borderColor = UIColor.white.cgColor
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self

        FriendSystem.system.addReplyObserver {
            self.tableView.reloadData()
        }

    }
    @IBAction func doneButtonTapped(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reveal")
        self.present(vc!, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FriendSystem.system.replyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create cell
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        if cell == nil {
            tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
            cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        }
        
        cell?.rightButton.isEnabled = false
        cell?.leftButton.isEnabled = false
        FriendSystem.system.getUser(FriendSystem.system.replyList[indexPath.row].personReplyingID, completion: { (user) in
            cell?.label.text = user.name
        })
        
        if(FriendSystem.system.replyList[indexPath.row].reply == "Yes")
        {
            cell?.leftButton.alpha = 0
            cell?.rightButton.alpha = 1
            cell?.rightButton.setTitleColor(UIColor.green, for: UIControlState.disabled)
            cell?.rightButton.setTitle("Accepted", for: UIControlState.disabled)
        }
        else
        {
            cell?.leftButton.setTitleColor(UIColor.red, for: UIControlState.disabled)
            cell?.leftButton.alpha = 1
            cell?.rightButton.alpha = 0
            cell?.leftButton.setTitle("Declined", for: UIControlState.disabled)
        }
        
        return cell!
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FriendSystem.system.removeReplyObserver()
    }
}
