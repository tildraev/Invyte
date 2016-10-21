//
//  EventCell.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/19/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class EventCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var descriptionButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    var descriptionButtonFunc: (() -> (Void))!
    var acceptButtonFunc: (() -> (Void))!
    var declineButtonFunc: (() -> (Void))!
    
    @IBAction func descriptionButtonTapped(_ sender: AnyObject) {
        descriptionButtonFunc()
    }
    
    @IBAction func acceptButtonTapped(_ sender: AnyObject) {
        acceptButtonFunc()
    }
    
    @IBAction func declineButtonTapped(_ sender: AnyObject) {
        declineButtonFunc()
    }
    
    func setDescriptionButtonAction(_ function: @escaping ()-> Void){
        self.descriptionButtonFunc = function
    }
    func setAcceptButtonAction(_ function: @escaping ()-> Void){
        self.acceptButtonFunc = function
    }
    func setDeclineButtonAction(_ function: @escaping ()-> Void){
        self.declineButtonFunc = function
    }
    

}
