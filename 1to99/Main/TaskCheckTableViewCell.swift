//
//  TaskCheckTableViewCell.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/26.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class TaskCheckTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
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
