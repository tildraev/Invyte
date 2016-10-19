//
//  MainMenu.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/4/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase

class MainMenu : UIViewController {
    
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
            loggedInAsLabel.text?.append(user.email!)
        }
        else{
            loggedInAsLabel.text = "Logged in as: "
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
