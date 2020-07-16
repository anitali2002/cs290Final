//
//  NutritionTableViewCell.swift
//  ScotlandApp
//
//  Created by Anita Li on 4/12/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit

class NutritionTableViewCell: UITableViewCell {

    @IBOutlet weak var nutritionLabel: UILabel!
    @IBOutlet weak var nutritionAmt: UILabel!
    @IBOutlet weak var nutritionUnit: UILabel!
    @IBOutlet weak var percentNeeds: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
