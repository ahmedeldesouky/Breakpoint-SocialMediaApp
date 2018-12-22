//
//  CreateGroupsVC.swift
//  Breakpoint
//
//  Created by Ahmed Mohamed El-Desouky on 12/19/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupsVC: UIViewController {

    @IBOutlet weak var titleTxt: InsertTextField!
    @IBOutlet weak var descriptionTxt: InsertTextField!
    @IBOutlet weak var addPeopleTxt: InsertTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupMemberlbl: UILabel!
    @IBOutlet weak var DoneOutletBtn: UIButton!
    
    var emailArray = [String]()
    var chosenUserArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        addPeopleTxt.delegate = self
        addPeopleTxt.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DoneOutletBtn.isHidden = true
    }
    
    @objc func textFieldDidChange() {
        if addPeopleTxt.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: addPeopleTxt.text!) { (returnedemailArray) in
                self.emailArray = returnedemailArray
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        if titleTxt.text != "" && descriptionTxt.text != "" {
            DataService.instance.getIds(forUsernames: chosenUserArray) { (idsArray) in
                var userIds = idsArray
                userIds.append((Auth.auth().currentUser?.uid)!)
                
                DataService.instance.createGroup(withTitle: self.titleTxt.text!, withDescription: self.descriptionTxt.text!, forUserIds: userIds, handler: { (groupCreated) in
                    if groupCreated {
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        print("There was an Error. Plese try again later.")
                    }
                })
            }
        }
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}


extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        let profileIamge = UIImage(named: "defaultProfileImage")
        
        // checkmark appear only while click cell
        if chosenUserArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(profileImage: profileIamge!, email: emailArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(profileImage: profileIamge!, email: emailArray[indexPath.row], isSelected: false)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        if !chosenUserArray.contains(cell.emailLbl.text!) {
            chosenUserArray.append(cell.emailLbl.text!)
            groupMemberlbl.text = chosenUserArray.joined(separator: ", ")
            DoneOutletBtn.isHidden = false
        } else {
            chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLbl.text! })
            if chosenUserArray.count >= 1 {
                groupMemberlbl.text = chosenUserArray.joined(separator: ", ")
            } else {
                groupMemberlbl.text = "add people to your group"
                DoneOutletBtn.isHidden = true
            }
        }
    }
}

extension CreateGroupsVC: UITextFieldDelegate {
    
}
