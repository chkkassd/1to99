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
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var title = ""
    let tasks = List<Task>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class Task: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var summary = ""
    let checkItems = List<CheckItem>()
    let owner = LinkingObjects(fromType: Plan.self, property: "tasks")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class CheckItem: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var content = ""
    @objc dynamic var isDone = false
    let owner = LinkingObjects(fromType: Task.self, property: "checkItems")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
