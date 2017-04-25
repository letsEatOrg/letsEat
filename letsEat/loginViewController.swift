//
//  loginViewController.swift
//  letsEat
//
//  Created by Prashant Bhandari on 3/28/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


class loginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let username = usernameTextField.text
        let password = passwordTextField.text
        PFUser.logInWithUsername(inBackground: username!, password: password!) { (logedInUser: PFUser?, loginError: Error?) in
            if let loginError = loginError {
                print(loginError.localizedDescription)
                let error = loginError.localizedDescription
                let alertViewController = UIAlertController(title: "LogIn Error", message: error, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertViewController.addAction(okAction)
                self.present(alertViewController, animated: true, completion: nil)
            }
            else {
                print("successfully logged In")
                MBProgressHUD.hide(for: self.view, animated: true)
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                
                // Query the user info class in the disk to get the data about
                // the logging in user.
                let userInfoQuery = PFQuery(className: "UserInfo")
                userInfoQuery.whereKey("username", equalTo:"\((username)!)")
                userInfoQuery.findObjectsInBackground(block: { (userInfoArray: [PFObject]?, error: Error?) in
                    if let userInfoArray = userInfoArray {
//                        print("userQueryArray: \(userInfoArray)")

                        var currentUserInfo: [String:String] = [:]
                        currentUserInfo["firstName"] = userInfoArray[0].object(forKey: "firstName") as? String
                        currentUserInfo["lastName"] = userInfoArray[0].object(forKey: "lastName") as? String
                        currentUserInfo["username"] = userInfoArray[0].object(forKey: "username") as? String
                        currentUserInfo["email"] = userInfoArray[0].object(forKey: "email") as? String

                        
//                        let userCurrent = currentUserInfo as NSDictionary
                        // this will save the logged in user as current user
                        User.currentUser = User(currentUserInfo: currentUserInfo as NSDictionary)
                    }
                    else {
                        print((error?.localizedDescription)!)
                    }
                    
                })
            }
        }
    }

    
/*
 * This bit of code is not need NOW as it is implemented in the signUp Viewcontroller
 * Not removing it because i might need it later, maybe.
 *
 */
    
    
//signUpButtonPressed function created by Prashant
    
//    @IBAction func signUpButtonPressed(_ sender: Any) {
//        let newUser = PFUser()
//        newUser.username = usernameTextField.text
//        newUser.password = passwordTextField.text
//        newUser.signUpInBackground { (successfulSignin: Bool, signUpError: Error?) in
//            if let signUpError = signUpError {
//                print(signUpError.localizedDescription)
//                let error = signUpError.localizedDescription
//                let alertViewController = UIAlertController(title: "SignUp Error", message: error, preferredStyle: .alert)
//                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertViewController.addAction(okAction)
//                self.present(alertViewController, animated: true, completion: nil)
//            }
//            else {
//                print("Successfully Signed Up New User")
//                self.performSegue(withIdentifier: "signUpSegue", sender: nil)
//            }
//        }
//        
//    }
    


}
