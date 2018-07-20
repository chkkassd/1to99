//
//  PlanHeaderFooterView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/20.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

enum HeaderFooter {
    case header
    case footer
}

class PlanHeaderFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        self.planLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 20))
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(named: "PlanTableColor")
        self.planLabel.text = "hahaha"
        self.addSubview(self.planLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var style: HeaderFooter = .header
    
    var planLabel: UILabel
}
