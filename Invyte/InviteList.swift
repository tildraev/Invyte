//
//  FriendInviteList.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/18/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class InviteList : UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect  = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        backgroundImage.addSubview(blurView)
        self.view.backgroundColor = UIColor.black
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
        //        if cell == nil {
        //            tableView.register(UINib(nibName: "UserInviteCell", bundle: nil), forCellReuseIdentifier: "UserInviteCell")
        //            cell = tableView.dequeueReusableCell(withIdentifier: "UserInviteCell") as? UserInviteCell
        //        }
        //
        //        // Modify cell
        //        cell!.button.setTitle("Accept", for: UICo1ntrolState())
        //        cell!.emailLabel.text = FriendSystem.system.requestList[(indexPath as NSIndexPath).row].email
        //
        //        cell!.setFunction {
        //            let id = FriendSystem.system.requestList[(indexPath as NSIndexPath).row].id
        //            FriendSystem.system.acceptFriendRequest(id!)
        //        }
        //
        //        // Return cell
        return cell!
    }
    

    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reveal")
        self.present(vc!, animated: true, completion: nil)
    }
    
}
