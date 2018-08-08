//
//  IndicatorView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/8/7.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import SSFGraphKit

let pointDiameter = 8
let pointSpace = 8

class IndicatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(frame: CGRect, count: Int) {
        self.init(frame: frame)
        self.count = count
    }
    
    var count: Int = 0 {
        didSet{
            if count != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    var selectedIndex: Int = 0 {
        didSet{
            if selectedIndex != oldValue {
                self.setNeedsDisplay()
            }
        }
    }
    
    private var combinedPointsDiagram: Diagram?
    
    private var points: [Diagram] = []
    
    private var combinedPointsFrame: CGRect {
        get {
            let width = pointDiameter*count+pointSpace*(count-1)
            let x = (self.bounds.width - CGFloat(width))/2
            let y = (self.bounds.height - CGFloat(pointDiameter))/2
            return CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(pointDiameter))
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard count > 0, selectedIndex >= 0 else { return }
        points.removeAll()
        for i in 1...count {
            if i-1 == selectedIndex {
                let point = Diagram.circle(diameter: 30.0).filled(UIColor(named:"PrimaryColor")!).aligned(to: CGPoint.center).stroked(UIColor(named:"PrimaryColor")!)
                points.append(point)
            } else {
                let point = Diagram.circle(diameter: 30.0).filled(UIColor.white).aligned(to: CGPoint.center).stroked(UIColor.white)
                points.append(point)
            }
        }
        combinedPointsDiagram = points.reduce(Diagram()){$0|||$1}
        
        guard let combinedPointsDiagram = self.combinedPointsDiagram else { return }
        let context = UIGraphicsGetCurrentContext()
        context?.draw(combinedPointsDiagram, in: combinedPointsFrame)
    }

}
