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
    
    lazy var allPlans = DataManager.sharedDataManager.allplans().sorted(byKeyPath: "date", ascending: false)
    
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planView.dataSource = self
        planView.delegate = self
        
        //receive data update nofitication and update UI
        notificationToken = allPlans.observe { [unowned self] changes in
            switch changes {
            case .initial:
                self.planView.reloadMutablePlanView()
            case .update(_, let deletions, let insertions, let modifications):
                //1.update the collectionview
                self.planView.planCollectionView.performBatchUpdates({
                    self.planView.planCollectionView.deleteItems(at: deletions.map{IndexPath(row:$0, section: 0)})
                    self.planView.planCollectionView.insertItems(at: insertions.map{IndexPath(row: $0, section: 0)})
                    self.planView.planCollectionView.reloadItems(at: modifications.map{IndexPath(row: $0, section: 0)})
                }, completion: nil)
                //2.update the page control
                self.planView.updatePageControl(deletions, insertions)
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
        presentAlert { text in
            let addedPlan = Plan.creatPlan(text)
            self.addPlanForInterfaceDriven(true, addedPlan, IndexPath(item: 0, section: 0))
        }
    }
    
    @IBAction func leftButtonPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showTaskView", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    //MARK: - Private methods
    private func presentAlert(handler: ((String) -> Void)? = nil) {
        let alert = UIAlertController(title: "你好", message: "请输入名称", preferredStyle: .alert)
        alert.addTextField { textfield in }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in }
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            guard let okHandler = handler else { return }
            //add a plan,interface-driven write
            let titleText = alert.textFields?.first?.text ?? ""
            okHandler(titleText)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    //Interface-driven write for plan
    private func addPlanForInterfaceDriven(_ isAdd: Bool, _ plan: Plan, _ indexPath: IndexPath) {
        let realm = try! Realm()
        realm.beginWrite()
        // add data
        if isAdd {
            realm.add(plan, update: true)
        } else {
            //cascading delete
            for task in plan.tasks {
                realm.delete(task.checkItems)
            }
            realm.delete(plan.tasks)
            realm.delete(plan)
        }
        //mirror it instantly in the UI
        self.planView.planCollectionView.performBatchUpdates({[unowned self] in
            if isAdd {
                self.planView.planCollectionView.insertItems(at: [indexPath])
            } else {
                self.planView.planCollectionView.deleteItems(at: [indexPath])
            }
        }, completion: { [unowned self] _ in
            if isAdd {
                self.planView.pageControl.numberOfPages += 1
                self.planView.planCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: false)
            } else {
                self.planView.pageControl.numberOfPages -= 1
            }
        })
        try! realm.commitWrite(withoutNotifying: [notificationToken!])
    }
    
    //Interface-driven write for task
    private func addTaskForInterfaceDriven(_ isAdd: Bool, _ planIndex: Int, _ task: Task) {
        let realm = try! Realm()
        realm.beginWrite()
        // add data
        if isAdd {
            let plan = allPlans[planIndex]
            realm.add(task, update: true)
            plan.tasks.append(task)
        } else {
            realm.delete(task)
        }
        //mirror it instantly in the UI
        self.planView.planCollectionView.performBatchUpdates({[unowned self] in
            self.planView.planCollectionView.reloadItems(at: [IndexPath(item: planIndex, section: 0)])
            }, completion: nil)
        try! realm.commitWrite(withoutNotifying: [notificationToken!])
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

extension SSFPlanViewController: SSFMutablePlanViewDelegate {
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, creatTaskAt planIndex: Int) {
        presentAlert { [unowned self] text in
            let task = Task.creatTask(text)
            self.addTaskForInterfaceDriven(true, planIndex, task)
        }
    }
    
//    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, deleteTaskAt index: MutablePlanViewIndex) {
//        let task = (allPlans[index.0].tasks)[index.1]
//        addTaskForInterfaceDriven(false, index.0, task)
//    }
}
