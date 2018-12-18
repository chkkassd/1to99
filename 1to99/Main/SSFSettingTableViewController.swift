//
//  SSFSettingTableViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/27.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import MessageUI

class SSFSettingTableViewController: UITableViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = "V".appending(AppInfoHelper.appVersion ?? "")
    }
    
    //MARK: - Private methods
    
    //select language
    private func presentLanguageActionsheet() {
        let alert = UIAlertController(title: "Hello".SSFLocalizedString, message: "Please select language".SSFLocalizedString, preferredStyle: .actionSheet)
        let enAction = UIAlertAction(title: "English".SSFLocalizedString, style: .default) {_ in
            //1.修改userdefaults
            UserDefaults.standard.set(["en", "zh-Hans"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            //2.切换bundle
            Bundle.loadLanguage()
            //3.重载刷新app
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
    
    //share
    private func shareToFriends() {
        let sharedText = "Creek To Do List".SSFLocalizedString
        let sharedImage = UIImage(named: "Creek")
        let sharedURL = URL(string: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=1446548601")
        let activityVC = UIActivityViewController(activityItems: [sharedText,sharedImage!,sharedURL!], applicationActivities: nil)
        activityVC.completionWithItemsHandler = {_, completed, _, activityError in
            if completed {
                
            } else {
                
            }
        }
        self.present(activityVC, animated: true, completion: nil)
    }
    
    //send feed back email
    private func sendFeedEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            self.noticeTop("You have not set Email client".SSFLocalizedString, autoClear: true, autoClearTime: 4)
            return
        }
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["peter1990lynn@gmail.com"])
        mailVC.setSubject("Feedback-Creek".SSFLocalizedString)
        self.present(mailVC, animated: true, completion: nil)
    }
    
    //open my weibo
    private func openMyWeibo() {
        //ios9之后检测是否装有某个app，需要配置白名单LSApplicationQueriesSchemes
        if UIApplication.shared.canOpenURL(URL(string: "weibo://")!) {
            UIApplication.shared.open(URL(string: "sinaweibo://userinfo?uid=2138535555")!, options: [:], completionHandler: nil)
        } else {
            self.noticeTop("You Have No Weibo Client".SSFLocalizedString, autoClear: true, autoClearTime: 4)
        }
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
                let appStoreCommnetView = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1446548601&pageNumber=0&sortOrdering=2&mt=8"
                UIApplication.shared.open(URL(string: appStoreCommnetView)!, options: [:], completionHandler: nil)
            } else if indexPath.row == 1 {
                shareToFriends()
            }
        case 2:
            if indexPath.row == 0 {
                sendFeedEmail()
            } else if indexPath.row == 1 {
                openMyWeibo()
            }
        default:
            return
        }
    }
}

extension SSFSettingTableViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .failed:
            self.dismiss(animated: true) {
                self.noticeTop("Fail To Send Email".SSFLocalizedString, autoClear: true, autoClearTime: 4)
            }
        case .saved:
            self.dismiss(animated: true) {
                self.noticeTop("Success To Save Email".SSFLocalizedString, autoClear: true, autoClearTime: 4)
            }
        case .sent:
            self.dismiss(animated: true) {
                self.noticeTop("Success To Send Email".SSFLocalizedString, autoClear: true, autoClearTime: 4)
            }
        default:
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
}
