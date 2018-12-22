//
//  GroupCell.swift
//  Breakpoint
//
//  Created by Ahmed Mohamed El-Desouky on 12/19/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    
    func configureCell(title: String, description: String, memberCount: Int) {
        self.groupLbl.text! = title
        self.descriptionLbl!.text = description
        self.membersLbl!.text = "\(memberCount) members."
    }
}
