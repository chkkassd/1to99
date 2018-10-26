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
    @objc dynamic var date = Date.init()
    let tasks = List<Task>()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class Task: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var summary = ""
    @objc dynamic var isDone = false
    @objc dynamic var date = Date()
    let checkItems = List<CheckItem>()
    let owner = LinkingObjects(fromType: Plan.self, property: "tasks")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

class CheckItem: Object {
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var content = ""
    @objc dynamic var isCheck = false
    let owner = LinkingObjects(fromType: Task.self, property: "checkItems")
    
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Plan {
    //creat
    class func creatPlan(_ title: String) -> Plan {
        let plan = Plan()
        plan.title = title
        return plan
    }
    
    //save and update
    func saveAndUpdateToRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    //delete
    func deletePlan() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
}

extension Task {
    //creat
    class func creatTask(_ summary: String) -> Task {
        let task = Task()
        task.summary = summary
        return task
    }
    
    //save and update
    func saveAndUpdateToRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    //delete
    func deleteTask() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
}

extension CheckItem {
    //creat
    class func creatCheckItem(_ content: String) -> CheckItem {
        let checkItem = CheckItem()
        checkItem.content = content
        return checkItem
    }
    
    //save and update
    func saveAndUpdateToRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
    //delete
    func deleteCheckItem() {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(self)
        }
    }
}
