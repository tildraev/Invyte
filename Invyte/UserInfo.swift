//
//  UserInfo.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/3/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase

class UserInfo : UIViewController {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.backgroundColor = UIColor.clear
        logoutButton.layer.cornerRadius = 5
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.borderColor = UIColor.white.cgColor
        
        self.view.backgroundColor = UIColor.black
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    @IBAction func logOutButtonTapped(_ sender: AnyObject) {
        do{
            try FIRAuth.auth()?.signOut()
        }
        catch{
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login Screen")
        self.present(vc!, animated: true, completion: nil)
    }
}
