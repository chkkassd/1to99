//
//  ConfigurationManager.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/12/4.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import Foundation
import UIKit

let ThemeColor = "ThemeColor"

struct ConfigurationManager {
    
    let configurationPlistURL = DirectoryPath().urlInDocument(with: "1to99.plist")
    
    //if first launch, set the default configuration
    func setAppConfigurationPlist() {
        guard let dic = ReadWriteFileManager().readPlistFile(from: configurationPlistURL) else {
            //if dic is nil, then write the default configuration to file
            let confiDic = [ThemeColor: "PrimaryColor"]
            currentThemeColor = UIColor(named: confiDic[ThemeColor]!)!
            (confiDic as NSDictionary).write(to: configurationPlistURL, atomically: true)
            return
        }
        currentThemeColor = UIColor(named: dic[ThemeColor] as! String)!
    }
    
    func changeThemeColorConfiguration(colorName: String) {
        if UIColor(named: colorName)!.isEqual(currentThemeColor) {return}
        guard var dic = ReadWriteFileManager().readPlistFile(from: configurationPlistURL) else {
            return
        }
        currentThemeColor = UIColor(named: colorName)!
        dic[ThemeColor] = colorName
        (dic as NSDictionary).write(to: configurationPlistURL, atomically: true)
    }
}
