//
//  SSFTaskTableViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/20.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

enum TaskSectionType: Int {
    case taskTips = 2//任务检查项
}

class SSFTaskTableViewController: UITableViewController {

    @IBOutlet weak var taskSummaryTextView: UITextView!
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var creatOrUpdateButton: UIButton!
    var checkTips = [["isDone": true, "title": "map用法"],["isDone": false, "title": "filter用法"],["isDone": true, "title": "reduce用法"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTaskCell()
    }

    // MARK - Private Methods
    
    private func configureTaskCell() {
        let taskCellNib = UINib(nibName: "TaskCheckTableViewCell", bundle: Bundle.main)
        self.tableView.register(taskCellNib, forCellReuseIdentifier: "TaskCheckTableViewCell")
    }
    
    // MARK: - Interaction
    
    @IBAction func creatOrUpdateButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func addCheckTipsPressed(_ sender: UITapGestureRecognizer) {
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == TaskSectionType.taskTips.rawValue {
            return checkTips.count
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TaskSectionType.taskTips.rawValue {
           let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCheckTableViewCell", for: indexPath) as! TaskCheckTableViewCell
            cell.checkButton.isSelected = checkTips[indexPath.row]["isDone"] as! Bool
            cell.contentLabel.text = checkTips[indexPath.row]["title"] as? String
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
