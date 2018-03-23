//
//  ViewController.swift
//  Locstagram
//
//  Created by Yusuke Ohashi on 2018/03/23.
//  Copyright © 2018 Yusuke Ohashi. All rights reserved.
//

import UIKit
import KeychainAccess

class ViewController: UIViewController {
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var authorizationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        refreshUIComponents()
    }
    
    fileprivate func refreshUIComponents() {
        do {
            if let accessToken = try Keychain(service: "Instagram").get("access_token") {
                signInButton.isHidden = true
                IG.biography(accessToken: accessToken, completion: {(user, error) in
                    DispatchQueue.main.async {
                        self.authorizationLabel.text = user?.data.username
                    }
                })
            }
        } catch {
            signInButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshUIComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
