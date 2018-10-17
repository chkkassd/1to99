//
//  DataModel.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/10/17.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import Foundation
import RealmSwift

class Plan: Object {
    @objc dynamic var title = ""
    let tasks = List<Task>()
}

class Task: Object {
    @objc dynamic var summary = ""
    @objc dynamic var owner: Plan?
    let checkItems = List<CheckItem>()
}

class CheckItem: Object {
    @objc dynamic var content = ""
    @objc dynamic var isDone = false
}
