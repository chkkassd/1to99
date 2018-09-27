//
//  SSFSettingTableViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/27.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class SSFSettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
