//
//  CustomCell.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/19/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class CustomCell: UITableViewCell {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    var leftButtonFunc: (() -> (Void))!
    var rightButtonFunc: (() -> (Void))!
    
    @IBAction func leftButtonTapped(_ sender: AnyObject) {
        leftButtonFunc()
    }
    
    @IBAction func rightButtonTapped(_ sender: AnyObject) {
        rightButtonFunc()
    }
    
    func setLeftButtonAction(_ function: @escaping () -> Void) {
        self.leftButtonFunc = function
    }
    
    func setRightButtonAction(_ function: @escaping () -> Void) {
        self.rightButtonFunc = function
    }
}
