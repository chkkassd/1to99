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
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "IDForShowSelectThemeColor", sender: self)
            } else if indexPath.row == 1 {
                
            }
        case 1:
            if indexPath.row == 0 {
                
            } else if indexPath.row == 1 {
                
            }
        case 2:
            if indexPath.row == 0 {
                
            } else if indexPath.row == 1 {
                
            } else if indexPath.row == 2 {
                
            }
        default:
            return
        }
    }
}
