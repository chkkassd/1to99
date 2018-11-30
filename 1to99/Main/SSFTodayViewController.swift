//
//  SSFTodayViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/28.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

class SSFTodayViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editeButton: UIBarButtonItem! {
        didSet {
            editeButton.addToThemeColorPool(propertyName: "tintColor")
        }
    }
    
    lazy var tasksForToday = DataManager.sharedDataManager.allTasks().filter("joinToday == YES").sorted(byKeyPath: "date", ascending: true)
    
    var tasksForTodayNotificationToken: NotificationToken?
    
    var searchResults = List<Task>()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        
        //receive today's taskdata update nofitication and update UI
        tasksForTodayNotificationToken = tasksForToday.observe { [unowned self] changes in
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                          with: .automatic)
                self.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                          with: .automatic)
                self.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                          with: .automatic)
                self.tableView.endUpdates()
            case .error(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    deinit {
        tasksForTodayNotificationToken?.invalidate()
    }
    
    // MARK: - Private methods
    
    private func configureSearchController() {
//        let todaySearchResultsVC = TodaySearchResultsViewController()
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.dimsBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
    }
    
    //Interface-driven write for join today's task
    private func operateTodayTaskForInterfaceDriven(_ operation: TaskOperation, _ indexPath: IndexPath, _ task: Task, repeatOperationHandler: (() -> Void)?) {
        let realm = try! Realm()
        realm.beginWrite()
        // add or delete or update data
        switch operation {
        case .removeFromToday:
            if !task.joinToday {
                (repeatOperationHandler ?? {})()
                try! realm.commitWrite(withoutNotifying: [tasksForTodayNotificationToken!])
                return
            } else {
                task.joinToday = false
                //mirror it instantly in the UI
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            //cascading delete
            realm.delete(task.checkItems)
            realm.delete(task)
            //mirror it instantly in the UI
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update(let dic):
            task.setValuesForKeys(dic)
            //mirror it instantly in the UI
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            try! realm.commitWrite(withoutNotifying: [tasksForTodayNotificationToken!])
            return
        }
        try! realm.commitWrite(withoutNotifying: [tasksForTodayNotificationToken!])
    }
    
    // MARK: - Interaction
    
    @IBAction func editBarButtonItemPressed(_ sender: Any) {
    }
}

extension SSFTodayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.navigationItem.searchController?.isActive)! {
            return searchResults.count
        } else {
            return tasksForToday.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayTableViewCell", for: indexPath) as! TodayTableViewCell
        cell.delegate = self
        
        var task: Task
        if (self.navigationItem.searchController?.isActive)! {
            task = searchResults[indexPath.row]
        } else {
            task = tasksForToday[indexPath.row]
        }
        cell.planTitleLabel.text = task.owner.first?.title
        cell.taskSummaryLabel.text = task.summary
        cell.processLabel.text = "\(task.checkItems.filter("isCheck == YES").count)/\(task.checkItems.count)"
        cell.checkButton.isSelected = task.isDone
        cell.pressCheck = {[unowned self] selected in
            self.operateTodayTaskForInterfaceDriven(.update(["isDone": selected]), indexPath, task, repeatOperationHandler: nil)
        }
        return cell
    }
}

extension SSFTodayViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {return}
        if searchResults.count > 0 {
            searchResults.removeAll()
        }
        for task in tasksForToday {
            if task.summary.localizedStandardContains(text) {
                searchResults.append(task)
            }
        }
        self.tableView.reloadData()
    }
}

extension SSFTodayViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let cell = tableView.cellForRow(at: indexPath) as! TodayTableViewCell
        let task = tasksForToday[indexPath.row]
        
        let deleteAction = SwipeAction(style: .destructive, title: "删除") { (action, index) in
            self.operateTodayTaskForInterfaceDriven(.delete, indexPath, task, repeatOperationHandler: nil)
            cell.hideSwipe(animated: true, completion: nil)
        }
        
        //remove from today list
        let removeTodayAction = SwipeAction(style: .default, title: "延后") { (action, index) in
            self.operateTodayTaskForInterfaceDriven(.removeFromToday, indexPath, task, repeatOperationHandler: {
                self.noticeTop("此任务已延后", autoClear: true, autoClearTime: 2)
            })
            cell.hideSwipe(animated: true, completion: nil)
        }
        return [deleteAction, removeTodayAction]
    }
}
