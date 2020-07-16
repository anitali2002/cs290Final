//
//  FridgeTableViewCell.swift
//  ScotlandApp
//
//  Created by Anita Li on 4/2/20.
//  Copyright © 2020 Zhixue (Mary) Wang. All rights reserved.
//

import UIKit

class FridgeTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func changeQty(_ sender: UIStepper) {
        quantity.text = Int(sender.value).description
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // possiby useful functions to adjust stepper settings
        // wraps: if set to true stepping beyond maximumvalue will return to minimumvalue
        // autorepeat: If set to true, the user pressing and holding on the stepper repeatedly alters value.
        // maximumvalue: the maximum value of the stepper
        stepper.value = 0
        stepper.wraps = false
        stepper.autorepeat = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
