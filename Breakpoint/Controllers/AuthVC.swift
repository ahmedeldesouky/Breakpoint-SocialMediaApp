//
//  AuthVC.swift
//  Breakpoint
//
//  Created by Ahmed Mohamed El-Desouky on 12/16/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit
import Firebase
import FacebookCore
import FacebookLogin

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func facebookBtn(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile, .email], viewController: self) { (result) in
            switch result {
            case .success(grantedPermissions: _, declinedPermissions: _, token: _):
                    self.signIntoFirebase()
                    print("Successfully logged in Facebook")
                
            case .failed(let err):
                print(err)
                
            case .cancelled:
                print("canselled")
            }
            print("Successfully authenticated with Firebase.")
        }
    }
    
    func signIntoFirebase() {
        guard let authToken = AccessToken.current?.authenticationToken else { return }
        let cardential = FacebookAuthProvider.credential(withAccessToken: authToken)
        Auth.auth().signInAndRetrieveData(with: cardential) { (user, err) in
            if let err = err {
                print(err)
                return
            }
        }
    }
    
    @IBAction func googleBtn(_ sender: Any) {
    }
    
    @IBAction func byemailBtn(_ sender: Any) {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
        present(loginVC!, animated: true, completion: nil)
    }
    
}
