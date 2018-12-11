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
    
    //MARK: - Private methods
    private func presentLanguageActionsheet() {
        let alert = UIAlertController(title: "Hello".SSFLocalizedString, message: "Please select language".SSFLocalizedString, preferredStyle: .actionSheet)
        let enAction = UIAlertAction(title: "English".SSFLocalizedString, style: .default) {_ in
            UserDefaults.standard.set(["en", "zh-Hans"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            Bundle.loadLanguage()
            self.reloadApp()
        }
        let chineseAction = UIAlertAction(title: "Chinese(Simplified)".SSFLocalizedString, style: .default) {_ in
            UserDefaults.standard.set(["zh-Hans", "en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            Bundle.loadLanguage()
            self.reloadApp()
        }
        let cancelAction = UIAlertAction(title: "Cancel".SSFLocalizedString, style: .cancel, handler: nil)
        alert.addAction(enAction)
        alert.addAction(chineseAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func reloadApp() {
        let tabbarVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SSFMainTabBarViewController")
        UIApplication.shared.keyWindow?.rootViewController = tabbarVC
    }
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "IDForShowSelectThemeColor", sender: self)
            } else if indexPath.row == 1 {
                presentLanguageActionsheet()
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
