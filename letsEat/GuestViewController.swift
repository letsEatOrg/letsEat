//
//  GuestViewController.swift
//  letsEat
//
//  Created by Prashant Bhandari on 4/11/17.
//  Copyright © 2017 Prashant Bhandari. All rights reserved.
//

import UIKit
import Parse

class GuestViewController: UIViewController {

    @IBOutlet weak var guestLabel: UILabel!
    
    var guest: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guestLabel.text = self.guest
    }
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
