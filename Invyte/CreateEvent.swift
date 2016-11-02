//
//  CreateEvent.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/3/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation

class CreateEvent : UIViewController, UITextViewDelegate{
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var eventTitleTextField: UITextView!
    @IBOutlet weak var eventDescriptionTextField: UITextView!
    @IBOutlet weak var findFriendsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findFriendsButton.backgroundColor = UIColor.clear
        findFriendsButton.layer.cornerRadius = 5
        findFriendsButton.layer.borderWidth = 1
        findFriendsButton.layer.borderColor = UIColor.white.cgColor
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func findFriendsButtonTapped(_ sender: AnyObject) {
        if eventTitleTextField.text != "" && eventDescriptionTextField.text != ""
        {
            //Create the event reference in Firebase
            let description = eventTitleTextField.text! + " - " + eventDescriptionTextField.text!
            FriendSystem.system.CURRENT_USER_EVENTS_REF.child(FriendSystem.system.CURRENT_USER_ID).setValue(description)
            
            //Present the invite list
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "InviteList")
            self.present(vc!, animated: true, completion: nil)
        }
        else
        {
            presentAlertView(issue: "Please fill out a title and description for your event.")
        }
    }
    
    func presentAlertView(issue: String) {
        let alertController = UIAlertController(title: "Error", message: issue, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    {
        if(text == "\n")
        {
            view.endEditing(true)
            return false
        }
        else
        {
            return true
        }
    }
    
}
