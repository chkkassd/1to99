//
//  DataManager.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/10/17.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import Foundation
import RealmSwift

class DataManager {
    // MARK: - Creat singleton
    static let sharedDataManager = DataManager()
    private init() {}
    
    // MARK: - Public Api
    
    //set default configuration
    public func setDefaultRealmConfiguration(_ userId: String) {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL?.deletingLastPathComponent().appendingPathComponent("\(userId).realm")
        config.shouldCompactOnLaunch = { totalBytes, usedBytes in
            let oneHundredMB = 100 * 1024 * 1024
            return (totalBytes > oneHundredMB) && (Double(usedBytes)/Double(totalBytes) < 0.5)
        }
        Realm.Configuration.defaultConfiguration = config
    }
    
    //Only used before realm opened or autorelease pool
    public func deleteCurrentRealm() {
        let url = Realm.Configuration.defaultConfiguration.fileURL
        guard let realmURL = url else { return }
        let realmURLs = [realmURL,
                         realmURL.appendingPathExtension("lock"),
                         realmURL.appendingPathExtension("note"),
                         realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do { try FileManager.default.removeItem(at: URL)
            } catch let error{
                print(error.localizedDescription)
            }
        }
    }
    
    //delete all objects
    public func deleteAllOfCurrentRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    //all plans in current realm
    public func allplans() -> Results<Plan> {
        let realm = try! Realm()
        return realm.objects(Plan.self)
    }
}
