//
//  profileViewController.swift
//  letsEat
//
//  Created by Prashant Bhandari on 3/29/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD


// TODO: maybe you shoud try and implement the resturent an user has visited in this
// view listed in a table view.
class profileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImageLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    var profileImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        let currentUser = User.currentUser
        nameLabel.text = "\((currentUser?.firstName)!) \((currentUser?.lastName)!)"
        
        let tempProfileImage: UIImage = profileImage ?? UIImage(named: "test_profile_pic")!
        profileImageLabel.image = tempProfileImage
        queryGuest()
    }
    
    
    // this will be called everytime the view appears, this is to update the profile 
    // picture.
    override func viewWillAppear(_ animated: Bool) {
//        setProfilePicture()
    }
    
   /*
    * TODO: Don't forget to come back to this part after you are
    *       done with the rest of the app.
    *       This is not that important to the funcationality of the app.
    *       just make sure to come back after your are done.
    */
 
    
    func setProfilePicture() {
        if (profileImage == nil) {
            let profilePictureQuery = PFQuery(className: "ProfilePicture_\((User.currentUser?.username)!)")
            profilePictureQuery.whereKeyExists("image")
            profilePictureQuery.findObjectsInBackground(block: { (photoArray: [PFObject]?, error: Error?) in
                if let photoArray = photoArray {
                    print(photoArray)
                }
            })
        }
        else {
            profileImageLabel.image = profileImage
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func logoutButton(_ sender: Any) {
        let alertCotroller = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alertCotroller.addAction(UIAlertAction(title: "logout", style: .default, handler: { (_) in
            MBProgressHUD.showAdded(to: self.view, animated: true)
            self.logoutUser()
        }))
        alertCotroller.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        present(alertCotroller, animated: true, completion: nil)
    }
    
     func logoutUser() {
        PFUser.logOutInBackground { (logoutError: Error?) in
            if logoutError == nil {
                User.currentUser = nil
                NotificationCenter.default.post(name: NSNotification.Name(NotificationKeys.logoutKey), object: self)
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            else {
                 print("error logging out")
            }
        }
    }
    
    
    @IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
//        NotificationSender.send(to: (User.currentUser?.username)!, from: (User.currentUser?.username)!)
    }
    
    @IBAction func profilePic(_ sender: UITapGestureRecognizer) {
        print("Profile picture tapped")
        let alertViewController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        alertViewController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
            self.openCamera()
        }))
        alertViewController.addAction(UIAlertAction(title: "Photo Gallery", style: .default, handler: { (_) in
            self.openPhotoGallery()
        }))
        alertViewController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertViewController, animated: true, completion: nil)

    }
    

    
    func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        else {
            let alertViewController = UIAlertController(title: "Oops!", message: "Couldn't find Camera", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func openPhotoGallery() {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage = editedImage
            profileImageLabel.image = editedImage
            // make sure you delete the older profile picture before or after saving the new one.
            SaveProfilePictureToDisk.saveProfilePicture(profilePicture: profileImage)
            dismiss(animated: true, completion: nil)
        }
        else {
            let alertViewController = UIAlertController(title: "Oops!", message: "Something went wrong while getting the image", preferredStyle: .alert)
            alertViewController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
    
    func queryGuest() {
            let query = PFQuery(className: "invitation")
            query.whereKey("requested", equalTo: true)
            query.whereKey("host", equalTo: "\((User.currentUser?.username)!)")
            query.whereKey("guest", notEqualTo: "none")
            query.order(byDescending: "createdAt")
            query.limit = 1
            
            query.findObjectsInBackground(block: { (respondArray: [PFObject]?, error: Error?) in
                if let respondArray = respondArray {
                    self.guest = respondArray[0].object(forKey: "guest") as? String
                }
                else {
                    print("error while loading invitaion data: \((error?.localizedDescription)!)")
                }
            })
        }
    
    var guest: String?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let guestVC = segue.destination as! GuestViewController
        guestVC.guest = guest
    }
//        if guestVC.guest == nil {
//            let query = PFQuery(className: "invitation")
//            query.whereKey("requested", equalTo: true)
//            query.whereKey("host", equalTo: "\((User.currentUser?.username)!)")
//            query.whereKey("guest", notEqualTo: "none")
//            query.order(byDescending: "createdAt")
//            query.limit = 1
//            
//            query.findObjectsInBackground(block: { (respondArray: [PFObject]?, error: Error?) in
//                if let respondArray = respondArray {
//                    guestVC.guest = respondArray[0].object(forKey: "guest") as? String
//                    //                self.guestLabel.text = self.guest
//                }
//                else {
//                    print("error while loading invitaion data: \((error?.localizedDescription)!)")
//                }
//            })
//        }
    
    
}
