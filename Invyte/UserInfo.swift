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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blurEffect  = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        backgroundImage.addSubview(blurView)
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
