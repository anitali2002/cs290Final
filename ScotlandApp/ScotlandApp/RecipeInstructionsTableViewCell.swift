//
//  RecipeInstructionsTableViewCell.swift
//  ScotlandApp
//
//  Created by Anita Li on 4/8/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit

class RecipeInstructionsTableViewCell: UITableViewCell {
    @IBOutlet weak var stepNumber: UILabel!
    @IBOutlet weak var step: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
