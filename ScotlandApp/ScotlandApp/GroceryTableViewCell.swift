//
//  GroceryTableViewCell.swift
//  ScotlandApp
//
//  Created by Zhixue (Mary) Wang on 4/8/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit

class GroceryTableViewCell: UITableViewCell {
    @IBOutlet weak var incomplete: UISwitch!
    @IBOutlet weak var foodItem: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
