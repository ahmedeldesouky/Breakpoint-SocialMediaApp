//
//  CreatePostVC.swift
//  Breakpoint
//
//  Created by Ahmed Mohamed El-Desouky on 12/17/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var statusTxt: UITextView!
    @IBOutlet weak var sendOutletBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        statusTxt.delegate = self
        sendOutletBtn.bindToKeyboard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.emailLbl.text = Auth.auth().currentUser?.email
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        if statusTxt.text != nil && statusTxt.text != "Say something here.." {
            sendOutletBtn.isEnabled = false
            DataService.instance.uploadPost(eithMessage: statusTxt.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil) { (isComplete) in
                if isComplete {
                    self.sendOutletBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    self.sendOutletBtn.isEnabled = true
                    print("There was an error!")
                }
            }
        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreatePostVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        statusTxt.text = ""
    }
}
