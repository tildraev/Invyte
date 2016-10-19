//
//  CreateEvent.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/3/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class CreateEvent : UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect  = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.backgroundImage.bounds
        backgroundImage.addSubview(blurView)
        
        //self.view.backgroundColor = UIColor.init(patternImage: #imageLiteral(resourceName: "GatsbyBackground"))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
