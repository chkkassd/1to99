//
//  TodayTableViewCell.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/28.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    @IBOutlet weak var planTitleLabel: UILabel!
    @IBOutlet weak var taskSummaryLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    
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
    }
}
