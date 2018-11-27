//
//  SSFPlanViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/20.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import RealmSwift

enum PlanOperation {
    case add
    case update([String: Any])
    case delete
}

enum TaskOperation {
    case add
    case delete
    case update([String: Any])
    case joinToToday
    case removeFromToday
}

class SSFPlanViewController: UIViewController {

    @IBOutlet weak var planView: SSFMutablePlanView!
    @IBOutlet weak var rightBarbuttonItem: UIBarButtonItem!
    @IBOutlet weak var blackBoardView: SSFBlackBoardView!
    
    lazy var allPlans = DataManager.sharedDataManager.allplans().sorted(byKeyPath: "date", ascending: false)
    
    var notificationToken: NotificationToken?
    
    lazy var tasksForToday = DataManager.sharedDataManager.allTasks().filter("joinToday == YES").sorted(byKeyPath: "date", ascending: true)
    
    var tasksForTodayNotificationToken: NotificationToken?
    
    var selectedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareForLoad()
        
        //receive plandata update nofitication and update UI
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
        
        //receive today's taskdata update nofitication and update UI
        tasksForTodayNotificationToken = tasksForToday.observe { [unowned self] changes in
            switch changes {
            case .initial:
                self.blackBoardView.collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                //1.update the collectionview
                self.blackBoardView.collectionView.performBatchUpdates({
                    self.blackBoardView.collectionView.deleteItems(at: deletions.map{IndexPath(row:$0, section: 0)})
                    self.blackBoardView.collectionView.insertItems(at: insertions.map{IndexPath(row: $0, section: 0)})
                    self.blackBoardView.collectionView.reloadItems(at: modifications.map{IndexPath(row: $0, section: 0)})
                }, completion: nil)
            case .error(let error):
                print(error.localizedDescription)
            }
            self.blackBoardView.todayProcessLabel.text = "\(self.tasksForToday.filter("isDone == YES").count)/\(self.tasksForToday.count)"
        }
    }
    
    deinit {
        notificationToken?.invalidate()
        tasksForTodayNotificationToken?.invalidate()
    }
    
    //MARK: - Action
    @IBAction func creatPlanButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController.presentAlertWithTextField(title: "你好", message: "请输入计划名称") { text in
            let addedPlan = Plan.creatPlan(text)
            self.operatePlanForInterfaceDriven(.add, addedPlan, IndexPath(item: 0, section: 0))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTaskView" {
            let taskVC = segue.destination as! SSFTaskTableViewController
            taskVC.displayedTask = selectedTask
        }
    }
    
    //MARK: - Private methods
    
    //prepare for show
    func prepareForLoad() {
        planView.dataSource = self
        planView.delegate = self
        blackBoardView.dataSource = self
    }
    
    //Interface-driven write for plan
    private func operatePlanForInterfaceDriven(_ operation: PlanOperation, _ plan: Plan, _ indexPath: IndexPath) {
        let realm = try! Realm()
        realm.beginWrite()
        switch operation {
        case .add:
            //add data
            realm.add(plan, update: true)
            //mirror it instantly in the UI
            self.planView.planCollectionView.performBatchUpdates({[unowned self] in
                self.planView.planCollectionView.insertItems(at: [indexPath])
                }, completion: { [unowned self] _ in
                    self.planView.pageControl.numberOfPages += 1
                    self.planView.planCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: UICollectionView.ScrollPosition.right, animated: false)
            })
        case .delete:
            //cascading delete
            for task in plan.tasks {
                realm.delete(task.checkItems)
            }
            realm.delete(plan.tasks)
            realm.delete(plan)
            //mirror it instantly in the UI
            self.planView.planCollectionView.performBatchUpdates({[unowned self] in
                self.planView.planCollectionView.deleteItems(at: [indexPath])
                }, completion: { [unowned self] _ in
                    self.planView.pageControl.numberOfPages -= 1
            })
        case .update(let dic):
            plan.setValuesForKeys(dic)
            //mirror it instantly in the UI
            self.planView.planCollectionView.performBatchUpdates({[unowned self] in
                self.planView.planCollectionView.reloadItems(at: [indexPath])
                }, completion: nil)
        }
        try! realm.commitWrite(withoutNotifying: [notificationToken!, tasksForTodayNotificationToken!])
    }
    
    //Interface-driven write for task
    private func operateTaskForInterfaceDriven(_ operation: TaskOperation, _ planIndex: Int, _ task: Task) {
        let realm = try! Realm()
        realm.beginWrite()
        // add or delete or update data
        switch operation {
        case .add:
            let plan = allPlans[planIndex]
            realm.add(task, update: true)
            plan.tasks.append(task)
        case .delete:
            //cascading delete
            realm.delete(task.checkItems)
            realm.delete(task)
        case .update(let dic):
            task.setValuesForKeys(dic)
        default:
            try! realm.commitWrite(withoutNotifying: [notificationToken!,tasksForTodayNotificationToken!])
            return
        }
        //mirror it instantly in the UI
        self.planView.planCollectionView.performBatchUpdates({[unowned self] in
            self.planView.planCollectionView.reloadItems(at: [IndexPath(item: planIndex, section: 0)])
            }, completion: nil)
        try! realm.commitWrite(withoutNotifying: [notificationToken!])
    }
    
    //Interface-driven write for join today's task
    private func operateTodayTaskForInterfaceDriven(_ operation: TaskOperation, _ task: Task, repeatAddHandler: () ->Void) {

        let realm = try! Realm()
        realm.beginWrite()
        // add or delete or update data
        switch operation {
        case .joinToToday://加入今天的计划
            if task.joinToday {
                repeatAddHandler()
                try! realm.commitWrite(withoutNotifying: [notificationToken!, tasksForTodayNotificationToken!])
                return
            } else {
               task.joinToday = true
            }
        case .removeFromToday://从今天的计划内移除
            if !task.joinToday {
                repeatAddHandler()
                try! realm.commitWrite(withoutNotifying: [notificationToken!, tasksForTodayNotificationToken!])
                return
            } else {
                task.joinToday = false
            }
        default:
            try! realm.commitWrite(withoutNotifying: [notificationToken!,tasksForTodayNotificationToken!])
            return
        }
        //mirror it instantly in the UI
        self.blackBoardView.collectionView.reloadData()
        self.blackBoardView.todayProcessLabel.text = "\(self.tasksForToday.filter("isDone == YES").count)/\(self.tasksForToday.count)"
        try! realm.commitWrite(withoutNotifying: [tasksForTodayNotificationToken!])
    }
}

extension SSFPlanViewController: SSFMutablePlanViewDataSource {
    func numberOfPlansInMutablePlanView(_ mutablePlanView: SSFMutablePlanView) -> Int {
        return allPlans.count//dataArr.count
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, numberOfTasksInPlan planIndex: Int) -> Int {
        return allPlans[planIndex].tasks.count
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, titleForPlan planIndex: Int) -> String {
        return allPlans[planIndex].title
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, taskForPlanAt indexPath: MutablePlanViewIndex) -> MutablePlanViewCellDic {
        let task = (allPlans[indexPath.0].tasks)[indexPath.1]
        return [MutablePlanViewCellDicKey.title: task.summary,MutablePlanViewCellDicKey.process: "\(task.checkItems.filter("isCheck == YES").count)/\(task.checkItems.count)",MutablePlanViewCellDicKey.check: task.isDone, MutablePlanViewCellDicKey.isTodayToDo: task.joinToday]
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, dragTaskForPlanAt indexPath: MutablePlanViewIndex) -> Task {
        return allPlans[indexPath.0].tasks[indexPath.1]
    }
}

extension SSFPlanViewController: SSFMutablePlanViewDelegate {
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, creatTaskAt planIndex: Int) {
        let alert = UIAlertController.presentAlertWithTextField(title: "你好", message: "请输入任务简述") { [unowned self] text in
            let task = Task.creatTask(text)
            self.operateTaskForInterfaceDriven(.add, planIndex, task)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, deleteTaskAt index: MutablePlanViewIndex) {
        let task = (allPlans[index.0].tasks)[index.1]
        operateTaskForInterfaceDriven(.delete, index.0, task)
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, addTaskTodayAt index: MutablePlanViewIndex) {
        let task = (allPlans[index.0].tasks)[index.1]
        operateTodayTaskForInterfaceDriven(.joinToToday, task) {
            self.noticeTop("此任务已在今日计划之列", autoClear: true, autoClearTime: 2)
        }
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, removeTaskFromTodayAt index: MutablePlanViewIndex) {
        let task = (allPlans[index.0].tasks)[index.1]
        operateTodayTaskForInterfaceDriven(.removeFromToday, task) {
            self.noticeTop("此任务已延后", autoClear: true, autoClearTime: 2)
        }
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, editePlanAt planIndex: Int) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let popoverVC = storyBoard.instantiateViewController(withIdentifier: "SSFPopoverTableViewController") as! SSFPopoverTableViewController
        popoverVC.planIndex = planIndex
        popoverVC.deletePlan = { index in
            self.operatePlanForInterfaceDriven(.delete, self.allPlans[index], IndexPath(item: index, section: 0))
            self.dismiss(animated: true, completion: nil)
        }
        popoverVC.rename = { index in
            let alert = UIAlertController.presentAlertWithTextField(title: "你好", message: "请输入计划名称") { text in
                let plan = self.allPlans[index]
                self.operatePlanForInterfaceDriven(.update(["title": text]), plan, IndexPath(item: index, section: 0))
            }
            self.dismiss(animated: true, completion: {
                self.present(alert, animated: true, completion: nil)
            })
        }
        popoverVC.preferredContentSize = CGSize(width: 180, height: 180)
        popoverVC.modalPresentationStyle = .popover
        popoverVC.popoverPresentationController?.delegate = self
        popoverVC.popoverPresentationController?.sourceView = planView
        popoverVC.popoverPresentationController?.sourceRect = CGRect(x: planView.bounds.size.width - 25 - 35, y: 5, width: 25, height: 25)
        popoverVC.popoverPresentationController?.permittedArrowDirections = .right
        self.present(popoverVC, animated: true, completion: nil)
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, didSelectTaskAt index: MutablePlanViewIndex) {
        self.selectedTask = allPlans[index.0].tasks[index.1]
        self.performSegue(withIdentifier: "showTaskView", sender: self)
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, didPressTaskCheckAt index: MutablePlanViewIndex, selected: Bool) {
        let task = allPlans[index.0].tasks[index.1]
        operateTaskForInterfaceDriven(.update(["isDone": selected]), index.0, task)
    }
}

extension SSFPlanViewController: UIPopoverPresentationControllerDelegate {
    //取消popover的自适应
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension SSFPlanViewController: SSFBlackBoardViewDatasource {
    func numberOfItems(in blackBoardView: SSFBlackBoardView) -> Int {
        return tasksForToday.count
    }
    
    func blackBoardView(_ blackBoardView: SSFBlackBoardView, updateDataSourceAt index: IndexPath, updateModel: BlackBoardViewUpdateModel, updatedData: Task) {
        operateTodayTaskForInterfaceDriven(.joinToToday, updatedData) {
            self.noticeTop("此任务已在今日计划之列", autoClear: true, autoClearTime: 2)
        }
    }
    
    func configureCell(_ collectionViewCell: UICollectionViewCell, cellForItemAt indexPath: IndexPath) {
        let cell = collectionViewCell as! BlackBoardCollectionViewCell
        let task = tasksForToday[indexPath.row]
        cell.taskImageView.image = task.isDone ? UIImage(named: "boardTaskDone") : UIImage(named: "boardTask")
    }
}
