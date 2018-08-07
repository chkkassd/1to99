//
//  SSFMutablePlanView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/23.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class SSFMutablePlanView: UIView {
    
    @IBOutlet var containView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var indicatorView: IndicatorView!
    
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
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(containView)
        
        indicatorView.count = 4

        
        scrollView.contentSize = CGSize(width: 1000.0, height:0)
    }
}

extension SSFMutablePlanView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("=====contentOffset:\(scrollView.contentOffset)==========\n")
        indicatorView.selectedIndex = Int(floor(scrollView.contentOffset.x/scrollView.frame.size.width))
    }
}
