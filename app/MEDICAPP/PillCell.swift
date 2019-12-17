//  Codigo tomado e inspirado por https://github.com/rffuste/ePill
//
//  PillCell.swift
//  MEDICAPP
//
//  Created by Gabriela Viñas on 9/29/19.
//  Copyright © 2019 Felipe Rivera. All rights reserved.
//

import Foundation
import UIKit


class PillCell: UITableViewCell {
    
    @IBOutlet weak var pillNameLabel: UILabel!
    @IBOutlet weak var pillTimeLabel: UILabel!
    @IBOutlet weak var pillImage: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
