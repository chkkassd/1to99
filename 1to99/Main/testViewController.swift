//
//  testViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/5.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBOutlet weak var mpv: SSFMutablePlanView!
    let dataArr = [[["title":"swift学习","process":"1/3","check": true],["title":"swift学习","process":"1/3","check": true],["title":"swift学习","process":"1/3","check": true]],
                   [["title":"python学习","process":"2/9","check": false],["title":"python学习","process":"2/9","check": false]],
                   [["title":"java学习","process":"2/3","check": true],["title":"java学习","process":"2/3","check": true]],
                   [["title":"c++学习","process":"1/4","check": false],["title":"c++学习","process":"1/4","check": false]],
                   [["title":"go学习","process":"1/5","check": true],["title":"go学习","process":"1/5","check": true]]]
    override func viewDidLoad() {
        super.viewDidLoad()

        mpv.dataSource = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("=========contentsize:\(mpv.scrollView.contentSize)===========\n==============stackframe:\(mpv.stackView.frame)=============\n==============scrollframe\(mpv.scrollView.frame)=============")
        
    }

    @IBAction func addAPlan(_ sender: UIButton) {
//        mpv.creatAPlanTable()

    }
}

extension testViewController: SSFMutablePlanViewDataSource {
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
