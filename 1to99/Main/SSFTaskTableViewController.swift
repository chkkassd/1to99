//
//  SSFTaskTableViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/20.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit

enum TaskSectionType: Int {
    case taskTips = 2//任务检查项
}

class SSFTaskTableViewController: UITableViewController {

    @IBOutlet weak var taskSummaryTextView: UITextView!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var creatOrUpdateButton: UIButton!

    var displayedTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskCell()
        self.taskSummaryTextView.text = displayedTask?.summary
        self.planLabel.text = displayedTask?.owner.first?.title
    }

    // MARK - Private Methods
    
    private func configureTaskCell() {
        let taskCellNib = UINib(nibName: "TaskCheckTableViewCell", bundle: Bundle.main)
        self.tableView.register(taskCellNib, forCellReuseIdentifier: "TaskCheckTableViewCell")
    }
    
    //Interface-driven write for checkItem
    private func operateCheckItemForInterfaceDriven(_ operation: PlanOperation, _ checkItem: CheckItem, _ indexPath: IndexPath) {
        let realm = try! Realm()
        realm.beginWrite()
        switch operation {
        case .add:
            //add data
            realm.add(checkItem, update: true)
            displayedTask?.checkItems.append(checkItem)
            //mirror it instantly in the UI
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        case .delete:
            //delete
            realm.delete(checkItem)
            //mirror it instantly in the UI
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        case .update(let dic):
            checkItem.setValuesForKeys(dic)
            //mirror it instantly in the UI
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        try! realm.commitWrite()
    }
    
    //update task's summary
    private func updateTask(with text: String) {
        guard let task = self.displayedTask else {return}
        Task.subsetUpdate(dic: ["id": task.id, "summary": text])
    }
    
    // MARK: - Interaction
    
    @IBAction func creatOrUpdateButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addCheckTipsPressed(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController.presentAlertWithTextField(title: "Hello".SSFLocalizedString, message: "PleaseInputCheckItem".SSFLocalizedString) { text in
            let checkItem = CheckItem.creatCheckItem(text)
            self.operateCheckItemForInterfaceDriven(.add, checkItem, IndexPath(row: self.displayedTask!.checkItems.count, section: TaskSectionType.taskTips.rawValue))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TaskSectionType.taskTips.rawValue {
            return (displayedTask?.checkItems.count) ?? 0
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TaskSectionType.taskTips.rawValue {
           let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCheckTableViewCell", for: indexPath) as! TaskCheckTableViewCell
            cell.delegate = self
            guard let task = displayedTask else {return cell}
            let checkItem = task.checkItems[indexPath.row]
            cell.checkButton.isSelected = checkItem.isCheck
            cell.contentLabel.text = checkItem.content
            cell.pressCheck = { [unowned self] isSeclect in
                self.operateCheckItemForInterfaceDriven(.update(["isCheck": isSeclect]), checkItem, indexPath)
            }
            return cell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.section == TaskSectionType.taskTips.rawValue {
            return super.tableView(tableView, indentationLevelForRowAt: IndexPath(item: 0, section: TaskSectionType.taskTips.rawValue))
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == TaskSectionType.taskTips.rawValue {
            return 44.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
}

extension SSFTaskTableViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            updateTask(with: taskSummaryTextView.text)
            return false
        }
        return true
    }
}

extension SSFTaskTableViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard let task = displayedTask else { return nil }
        let cell = tableView.cellForRow(at: indexPath) as! TaskCheckTableViewCell
        let deleteAction = SwipeAction(style: .destructive, title: "Delete".SSFLocalizedString) { (action, index) in
            let checkItem = task.checkItems[index.row]
            self.operateCheckItemForInterfaceDriven(.delete, checkItem, index)
            cell.hideSwipe(animated: true, completion: nil)
        }
        let reInputAction = SwipeAction(style: .default, title: "Modify".SSFLocalizedString) { (action, index) in
            let checkItem = task.checkItems[index.row]
            let alert = UIAlertController.presentAlertWithTextField(title: "Hello".SSFLocalizedString, message: "PleaseInputCheckItem".SSFLocalizedString, handler: { text in
                self.operateCheckItemForInterfaceDriven(.update(["content": text]), checkItem, index)
            })
            cell.hideSwipe(animated: true, completion: nil)
            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction, reInputAction]
    }
}
