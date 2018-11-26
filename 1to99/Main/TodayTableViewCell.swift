//
//  TodayTableViewCell.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/28.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import SwipeCellKit

class TodayTableViewCell: SwipeTableViewCell {

    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var taskSummaryLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var pressCheck: (Bool) -> Void = {_ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        pressCheck(sender.isSelected)
    }
}
