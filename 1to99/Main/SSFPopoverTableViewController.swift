//
//  SSFPopoverTableViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/10/30.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class SSFPopoverTableViewController: UITableViewController {

    var planIndex: Int = 0
    var rename: ((Int) -> Void)?
    var deleteFinishedTasks: ((Int) -> Void)?
//    var archivePlan: ((Int) -> Void)?
    var deletePlan: ((Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            guard let closure = rename else {return}
            closure(planIndex)
        case 1:
            guard let closure = deleteFinishedTasks else {return}
            closure(planIndex)
        case 2:
            guard let closure = deletePlan else {return}
            closure(planIndex)
        default:
            return
        }
    }
}
