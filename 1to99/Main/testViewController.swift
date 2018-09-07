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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        print("=========contentsize:\(mpv.scrollView.contentSize)===========\n==============stackframe:\(mpv.stackView.frame)=============\n==============scrollframe\(mpv.scrollView.frame)=============")
        
    }

    @IBAction func addAPlan(_ sender: UIButton) {
        mpv.creatAPlanTable()

    }
}
