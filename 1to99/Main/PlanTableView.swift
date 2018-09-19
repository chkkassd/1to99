//
//  PlanTableView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/23.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class PlanTableView: UITableView {
    
    class func getAPlanTableView() -> PlanTableView {
        return Bundle.main.loadNibNamed("PlanTableView", owner: nil, options: nil)?.first as! PlanTableView
    }
    
    @IBOutlet weak var planTitle: UILabel!
    
    var planTableIndex: Int = 0
    
    var creatTask: (Int) -> Void = {_ in }
    
    var editPlan: (Int) -> Void = {_ in }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        
    }
    
    @IBAction func creatTaskButtonPressed(_ sender: UIButton) {
        creatTask(planTableIndex)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        editPlan(planTableIndex)
    }
    
}
