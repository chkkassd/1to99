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
    
    var dataArr: [[[String: String]]] = []/*[[["title":"swift学习","process":"1/3","check": true],["title":"swift学习","process":"1/3","check": true],["title":"swift学习","process":"1/3","check": true]],
                   [["title":"python学习","process":"2/9","check": false],["title":"python学习","process":"2/9","check": false]],
                   [["title":"java学习","process":"2/3","check": true],["title":"java学习","process":"2/3","check": true]],
                   [["title":"c++学习","process":"1/4","check": false],["title":"c++学习","process":"1/4","check": false]]]*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planView.dataSource = self
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
        alert.addTextField { textfield in
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        let okAction = UIAlertAction(title: "确定", style: .default) { _ in
            //update data
            let titleText = alert.textFields?.first?.text ?? ""
            Plan.creatPlan(titleText).saveAndUpdateToRealm()
            //Update the plan view
            self.planView.creatPlanView(at: 0)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
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
