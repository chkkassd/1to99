//
//  SSFPlanViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/20.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class SSFPlanViewController: UIViewController {

    @IBOutlet weak var planView: SSFMutablePlanView!
    
    var dataArr = [[["title":"swift学习","process":"1/3","check": true],["title":"swift学习","process":"1/3","check": true],["title":"swift学习","process":"1/3","check": true]],
                   [["title":"python学习","process":"2/9","check": false],["title":"python学习","process":"2/9","check": false]],
                   [["title":"java学习","process":"2/3","check": true],["title":"java学习","process":"2/3","check": true]],
                   [["title":"c++学习","process":"1/4","check": false],["title":"c++学习","process":"1/4","check": false]]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planView.dataSource = self
    }
    
    @IBAction func creatPlanButtonPressed(_ sender: UIBarButtonItem) {
        //Update the data
        dataArr.insert([], at: 0)
        //Update the plan view
        planView.creatPlanView(at: 0)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

extension SSFPlanViewController: SSFMutablePlanViewDataSource {
    func numberOfPlansInMutablePlanView(_ mutablePlanView: SSFMutablePlanView) -> Int {
        return dataArr.count
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, numberOfTasksInPlan planIndex: Int) -> Int {
        return dataArr[planIndex].count
    }
    
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, taskForPlanAt indexPath: MutablePlanViewIndex) -> MutablePlanViewCellDic {
        let dataDic = dataArr[indexPath.0][indexPath.1]
        return [MutablePlanViewCellDicKey.title: (dataDic["title"] as! String),MutablePlanViewCellDicKey.process: (dataDic["process"] as! String),MutablePlanViewCellDicKey.check: (dataDic["check"] as! Bool)]
    }
}
