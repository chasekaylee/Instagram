//
//  UserCell.swift
//  Instagram
//
//  Created by Chase Lee on 2/3/16.
//  Copyright © 2016 Chase Lee. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var photoView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
