//
//  SSFMutablePlanView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/23.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class SSFMutablePlanView: UIView {
    @IBOutlet var scrollView: UIScrollView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("MainPlanView", owner: self, options: nil)
        scrollView.frame = self.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(scrollView)
        
//        let a = UIView(frame: self.bounds)
//        a.backgroundColor = UIColor.red
//
//        let b = UIView(frame: self.bounds.offsetBy(dx: self.bounds.width, dy: 0))
//        b.backgroundColor = UIColor.blue
//        
//        scrollView.addSubview(a)
//        scrollView.addSubview(b)
        scrollView.contentSize = CGSize(width: 1000.0, height:0)
    }
}
