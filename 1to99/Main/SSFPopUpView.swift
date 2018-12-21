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
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var medalImageView: UIImageView!
    @IBOutlet weak var DetailTextView: UITextView!
    var detailText: String? {
        didSet {
            DetailTextView.text = detailText
            showViewAnimation()
            showDetailTextAnimation()
        }
    }
    var okButtonCompletion: (() -> Void)?
    
    // MARK: - Creat singleton
    static let sharedPopUpView = SSFPopUpView()
    private init() {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
//    convenience init(frame: CGRect, details: String) {
//        self.init(frame: frame)
//        self.DetailTextView.text = details
//        showDetailTextAnimation()
//    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SSFPopUpView", owner: self, options: nil)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(containView)
//        showViewAnimation()
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        guard let completion = okButtonCompletion else {return}
        completion()
    }
    
    private func showViewAnimation() {
        let originTopCenter = topLabel.center
        topLabel.center = CGPoint(x: originTopCenter.x, y: originTopCenter.y + 40.0)
        let originImageViewFrame = medalImageView.frame
        medalImageView.frame = CGRect(x: medalImageView.center.x
            , y: medalImageView.center.y, width: 0, height: 0)
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
            self.topLabel.center = originTopCenter
            self.medalImageView.frame = originImageViewFrame
        }, completion: nil)
        
        let originTitleCenter = titleLabel.center
        titleLabel.center = CGPoint(x: originTitleCenter.x, y: originTitleCenter.y + 40.0)
        titleLabel.alpha = 0.0
        let originOkButtonCenter = okButton.center
        okButton.center = CGPoint(x: originOkButtonCenter.x, y: originOkButtonCenter.y + 20.0)
        okButton.alpha = 0.0
        UIView.animate(withDuration: 2, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
            self.titleLabel.center = originTitleCenter
            self.titleLabel.alpha = 1
            self.okButton.center = originOkButtonCenter
            self.okButton.alpha = 1.0
        }, completion: nil)
    }
    
    private func showDetailTextAnimation() {
        let originDetailTextCenter = DetailTextView.center
        DetailTextView.center = CGPoint(x: originDetailTextCenter.x, y: originDetailTextCenter.y + 60.0)
        DetailTextView.alpha = 0.0
        UIView.animate(withDuration: 2, delay: 2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.DetailTextView.center = originDetailTextCenter
            self.DetailTextView.alpha = 1.0
        }, completion: nil)
    }
}
