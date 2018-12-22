//
//  GroupsVC.swift
//  Breakpoint
//
//  Created by Ahmed Mohamed El-Desouky on 12/15/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit
import Firebase

class GroupsVC: UIViewController {

    @IBOutlet weak var groupTableview: UITableView!

    var groupsArray = [Groups]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       groupTableview.delegate = self
       groupTableview.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //opserve groups data at any time
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.groupTableview.reloadData()
        }
      }
   }
}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupTableview.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else { return UITableViewCell() }
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDescription, memberCount: group.memberCount)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else { return }
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
//        present(groupFeedVC, animated: true, completion: nil)

        presentDetail(groupFeedVC)
    }
}
