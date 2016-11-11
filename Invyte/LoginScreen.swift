//
//  LoginScreen.swift
//  Invyte
//
//  Created by Arian Mohajer on 10/3/16.
//  Copyright © 2016 Arian Mohajer. All rights reserved.
//

import Foundation
import Firebase
import UserNotifications

class LoginScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let myKeychainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let storedUsername = UserDefaults.standard.value(forKey: "username") as? String {
            emailTextField.text = storedUsername as String
        }
        
        // Do any additional setup after loading the view, typically from a nib
        self.view.backgroundColor = UIColor.black
        let imageView = UIImageView(image: #imageLiteral(resourceName: "GatsbyBackground"))
        imageView.alpha = 0.03
        
        self.backgroundImage = imageView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
 
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            
        }
        else
        {
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                if error == nil
                {
                    //Keychain stuff
                    //Do keychain stuff here
                    //if (hasLoginKey == false) {
                        UserDefaults.standard.setValue(self.emailTextField.text, forKey: "username")
                    //}
                    
                    self.myKeychainWrapper.mySetObject(self.passwordTextField.text, forKey: kSecValueData)
                    self.myKeychainWrapper.writeToKeychain()
                    UserDefaults.standard.set(true, forKey: "hasLoginKey")
                    UserDefaults.standard.synchronize()
                    
                    if self.checkLogin(username: self.emailTextField.text!, password: self.passwordTextField.text!){
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Reveal")
                        self.present(vc!, animated: true, completion: nil)
                    }
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            })
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateAccount")
        present(vc!, animated: true, completion: nil)
    }
    
    
    @IBAction func resetPasswordButtonTapped(_ sender: AnyObject) {
        let prompt = UIAlertController.init(title: nil, message: "Enter email to reset password:", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            let userInput = prompt.textFields![0].text
            if (userInput!.isEmpty) {
                return
            }
            FIRAuth.auth()?.sendPasswordReset(withEmail: userInput!) { (error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Oops!", message: error.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    let alertController = UIAlertController(title: "Success!", message: "Password reset email sent!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        prompt.addTextField(configurationHandler: nil)
        prompt.addAction(okAction)
        present(prompt, animated: true, completion: nil);
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }
    
    
    func checkLogin(username: String, password: String ) -> Bool {
        if password == myKeychainWrapper.myObject(forKey: "v_Data") as? String &&
            username == UserDefaults.standard.value(forKey: "username") as? String {
            return true
        } else {
            return false
        }
    }
    
}
