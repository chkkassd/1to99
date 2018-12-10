//
//  LocalizableProtocol.swift
//
//传统的storyboard国际化方法有诸多缺点
//1.增加新的UI组件后，xib文件无法自动更新
//2.可读性差，使用objectID
//3.代码国际化和xib国际化使用两份.strings文件，无法复用，实在不合理，有诸多重复
//我们使用协议扩展的方法，利用User Defined Runtime Attributes来实现复用Localizable.strings实现国际化
//
//  Created by 赛峰 施 on 2018/12/10.
//  Copyright © 2018年 PETER SHI. All rights reserved.

import Foundation
import UIKit

protocol Localizable {
    var SSFLocalizedString: String {get}
}

extension String: Localizable {
    var SSFLocalizedString: String {
        return NSLocalizedString(self, comment: "")
    }
}

protocol XIBLocalizable {
    var xibLocalKey: String? {set get}
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocalKey: String? {
        get {return nil}
        set(key) {
            text = key?.SSFLocalizedString
        }
    }
}

extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocalKey: String? {
        get {return nil}
        set(key) {
            setTitle(key?.SSFLocalizedString, for: .normal)
        }
    }
}

extension UIBarItem: XIBLocalizable {
    @IBInspectable var xibLocalKey: String? {
        get {return nil}
        set(key) {
            title = key?.SSFLocalizedString
        }
    }
}

extension UINavigationItem: XIBLocalizable {
    @IBInspectable var xibLocalKey: String? {
        get {return nil}
        set(key) {
            title = key?.SSFLocalizedString
        }
    }
}
