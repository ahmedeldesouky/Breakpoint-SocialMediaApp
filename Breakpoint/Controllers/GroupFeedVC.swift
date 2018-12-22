//
//  GroupFeedVC.swift
//  Breakpoint
//
//  Created by Ahmed Mohamed El-Desouky on 12/21/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var groubTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var messageTxt: InsertTextField!
    @IBOutlet weak var sendmsgOutletBtn: UIButton!
    @IBOutlet weak var sendbtnView: UIView!
    
    var group: Groups?
    var groupMessages = [Message]()
    
    func initData(forGroup group: Groups) {
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendmsgOutletBtn.bindToKeyboard()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        groubTitleLbl.text = group?.groupTitle
        DataService.instance.getEmailsFor(group: group!) { (returnedEmails) in
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        }
        DataService.instance.REF_GROUPS.observe(.value) { (snapShot) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func sendBtn(_ sender: Any) {
        if messageTxt.text != "" {
            messageTxt.isEnabled = false
            sendmsgOutletBtn.isEnabled = false
            DataService.instance.uploadPost(eithMessage: messageTxt.text!, forUID: Auth.auth().currentUser!.uid, withGroupKey: group?.key) { (complete) in
                if complete {
                    self.messageTxt.text = ""
                    self.messageTxt.isEnabled = true
                    self.sendmsgOutletBtn.isEnabled = true
                }
            }
        }
    }
}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell() }
        let message = groupMessages[indexPath.row]
        
        DataService.instance.getUsername(forUID: message.senderId) { (email) in
            cell.configureCell(profileImgage: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)
        }
        return cell
    }
}
