//
//  CreateAccount.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/5/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase

class CreateAccount : UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
    }
    
    
    @IBAction func createButtonTapped(_ sender: AnyObject) {
        
        //If any fields left blank
        if (self.emailTextField.text == "" || self.passwordTextField.text == "" || passwordConfirmTextField.text == "" || usernameTextField.text == "" || firstNameTextField.text == "" || lastNameTextField.text == "")
        {
            presentAlertView(issue: "Please fill out all fields.")
        }
        //If passwords don't match
        else if self.passwordTextField.text != self.passwordConfirmTextField.text
        {
            presentAlertView(issue: "The passwords provided did not match. Please try again.")
        }
        else
        {
            //Check to see if the username is already taken
            self.ref.child("users").queryOrdered(byChild: "Username").queryEqual(toValue: self.usernameTextField.text!).observeSingleEvent(of: .value, with: { (snapshot) in
                if(snapshot.value is NSNull)
                {
                    // No user with that username. Continue.
                    //Create the user
                    FriendSystem.system.createAccount(self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (success) in
                        if success {
                            
                        }
                        else{
                            
                        }
                    })
                    FIRAuth.auth()?.createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                        if error == nil
                        {
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reveal")
                            self.present(vc!, animated: true, completion: nil)
                            self.ref.child("users").child(user!.uid).setValue(["Name": self.firstNameTextField.text!.lowercased() + " " + self.lastNameTextField.text!.lowercased(), "Email": self.emailTextField.text!, "Score": 0, "Username": self.usernameTextField.text!.lowercased()])
                        }
                        else
                        {
                            self.presentAlertView(issue: (error?.localizedDescription)!)
                        }
                    })
                    
                }
                else
                {
                    self.presentAlertView(issue: "That username is already taken. Please try a different username.")                }
                }, withCancel: { (error) in
                    print(error)
            })
        }
    }
    
    func presentAlertView(issue: String) {
        let alertController = UIAlertController(title: "Error", message: issue, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
}
