//
//  SSFPlanViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/20.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import RealmSwift

class SSFPlanViewController: UIViewController {

    @IBOutlet weak var planView: SSFMutablePlanView!
    
    /*var dataArr: [[[String: String]]] = [] [[["title":"swift学习","process":"1/3","check": true],["title":"swift学习","process":"1/3","check": true],["title":"swift学习","process":"1/3","check": true]],
                   [["title":"python学习","process":"2/9","check": false],["title":"python学习","process":"2/9","check": false]],
                   [["title":"java学习","process":"2/3","check": true],["title":"java学习","process":"2/3","check": true]],
                   [["title":"c++学习","process":"1/4","check": false],["title":"c++学习","process":"1/4","check": false]]]*/
    lazy var allPlans = DataManager.sharedDataManager.allplans()
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planView.dataSource = self
        
        //receive data update nofitication and update UI
        notificationToken = allPlans.observe { [weak self] changes in
            switch changes {
            case .initial:
                self?.planView.reloadMutablePlanView()
            case .update(_, let deletions, let insertions, let modifications):
                //1.update the collectionview
                self?.planView.planCollectionView.performBatchUpdates({
                    self?.planView.planCollectionView.deleteItems(at: deletions.map{IndexPath(row:$0, section: 0)})
                    self?.planView.planCollectionView.insertItems(at: insertions.map{IndexPath(row: $0, section: 0)})
                    self?.planView.planCollectionView.reloadItems(at: modifications.map{IndexPath(row: $0, section: 0)})
                }, completion: nil)
                //2.update the page control
                self?.planView.updatePageControl(deletions, insertions)
            case .error(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    //MARK: - Action
    @IBAction func creatPlanButtonPressed(_ sender: UIBarButtonItem) {
        presentAlert()
    }
    
    @IBAction func leftButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showTaskView", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //MARK: - Private methods
    private func presentAlert() {
        let alert = UIAlertController(title: "你好", message: "请输入名称", preferredStyle: .alert)
        alert.addTextField { textfield in }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in }
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            //add a plan
            let titleText = alert.textFields?.first?.text ?? ""
            Plan.creatPlan(titleText).saveAndUpdateToRealm()
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
}

extension SSFPlanViewController: SSFMutablePlanViewDataSource {
    func numberOfPlansInMutablePlanView(_ mutablePlanView: SSFMutablePlanView) -> Int {
        return allPlans.count//dataArr.count
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, numberOfTasksInPlan planIndex: Int) -> Int {
        return allPlans[planIndex].tasks.count//dataArr[planIndex].count
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, titleForPlan planIndex: Int) -> String {
        return allPlans[planIndex].title
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, taskForPlanAt indexPath: MutablePlanViewIndex) -> MutablePlanViewCellDic {
        let task = (allPlans[indexPath.0].tasks)[indexPath.1]//dataArr[indexPath.0][indexPath.1]
        return [MutablePlanViewCellDicKey.title: task.summary,MutablePlanViewCellDicKey.process: "\(task.checkItems.filter("isCheck == YES").count)/\(task.checkItems.count)",MutablePlanViewCellDicKey.check: task.isDone]
    }
}
