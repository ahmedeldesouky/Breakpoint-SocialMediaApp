//
//  ShadowView.swift
//  Breakpoint
//
//  Created by Ahmed Mohamed El-Desouky on 12/17/18.
//  Copyright © 2018 Ahmed El-Desouky. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    override func awakeFromNib() {
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        
        super.awakeFromNib()
    }
}
