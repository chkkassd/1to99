//
//  SSFPopUpView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/12/19.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class SSFPopUpView: UIView {

    @IBOutlet var containView: UIView!
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SSFPopUpView", owner: self, options: nil)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(containView)
    }
}
