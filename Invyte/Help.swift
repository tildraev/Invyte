//
//  Help.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/3/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class Help : UIViewController {
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.black
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
}
