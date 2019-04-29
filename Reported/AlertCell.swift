//
//  AlertCell.swift
//  Reported
//
//  Created by Jay Arellano on 4/2/19.
//  Copyright © 2019 threesannin. All rights reserved.
//

import UIKit

class AlertCell: UITableViewCell {
    
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var alertImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        print("ouch")
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
