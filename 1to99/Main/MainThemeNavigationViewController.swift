//
//  MainThemeNavigationViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/27.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class MainThemeNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationBar.addToThemeColorPool(propertyName: "barTintColor")
        self.navigationBar.addToThemeColorPool(propertyName: "tintColor")
    }
}
