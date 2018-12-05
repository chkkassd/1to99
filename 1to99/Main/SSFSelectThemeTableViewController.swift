//
//  SSFSelectThemeTableViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/12/5.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class SSFSelectThemeTableViewController: UITableViewController {

    @IBOutlet var colorTableCells: [UITableViewCell]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelectedColorCell()
    }
    
    private func clearAllCellsNone() {
        colorTableCells.forEach { cell in
            cell.accessoryType = .none
        }
    }
    
    private func setSelectedColorCell() {
        colorTableCells.forEach { cell in
            var color: UIColor
            if cell.tag == 311 {
                color = UIColor(named: "PrimaryColor")!
            } else if cell.tag == 312 {
                color = UIColor(named: "AirBlueColor")!
            } else if cell.tag == 313{
                color = UIColor(named: "ThinRedColor")!
            } else {
                color = UIColor(named: "PrimaryColor")!
            }
            if color.isEqual(currentThemeColor) {
                cell.accessoryType = .checkmark
                return
            }
        }
    }
    
    // MARK: table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        switch indexPath.row {
        case 0:
            ConfigurationManager().changeThemeColorConfiguration(colorName: "PrimaryColor")
            self.setAppThemeColor()
        case 1:
            ConfigurationManager().changeThemeColorConfiguration(colorName: "AirBlueColor")
            self.setAppThemeColor()
        case 2:
            ConfigurationManager().changeThemeColorConfiguration(colorName: "ThinRedColor")
            self.setAppThemeColor()
        default:
            ConfigurationManager().changeThemeColorConfiguration(colorName: "PrimaryColor")
            self.setAppThemeColor()
        }
        clearAllCellsNone()
        cell?.accessoryType = .checkmark
    }
}
