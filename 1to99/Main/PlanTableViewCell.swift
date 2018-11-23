//
//  PlanTableViewCell.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/20.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import SwipeCellKit

class PlanTableViewCell: SwipeTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var processLable: UILabel!
    @IBOutlet weak var todayToDoLabel: UILabel!
    
    var pressCheck: (Bool) -> Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func checkButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        pressCheck(sender.isSelected)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
