//
//  FeedCell.swift
//  Breakpoint
//
//  Created by Ahmed Mohamed El-Desouky on 12/17/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    func configureCell(profileImgage: UIImage, email: String, content: String) {
        self.profileImg.image = profileImgage
        self.emailLbl.text = email
        self.contentLbl.text = content
    }
}
