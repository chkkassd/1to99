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
    var allPlanTables: [PlanTableView] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("MainPlanView", owner: self, options: nil)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(containView)
        
        creatAPlanTable()
        
        
        indicatorView.count = allPlanTables.count

        
        scrollView.contentSize = CGSize(width: 1000.0, height:0)
    }
    
    public func creatAPlanTable() {
        let planTable = PlanTableView.getAPlanTableView()
//        planTable.translatesAutoresizingMaskIntoConstraints = false
        let cellNib = UINib(nibName: "PlanTableViewCell", bundle: Bundle.main)
        planTable.register(cellNib, forCellReuseIdentifier: "PlanTableViewCell")
        planTable.delegate = self
        planTable.dataSource = self
        scrollView.addSubview(planTable)
        
        
        planTable.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 15.0).isActive = true
        planTable.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0.0).isActive = true
        planTable.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0.0).isActive = true
        planTable.widthAnchor.constraint(equalToConstant: scrollView.frame.width - 30.0).isActive = true
        
        allPlanTables.append(planTable)
    }
    
    public func addTaskInPlanTable() {
        
    }
}

extension SSFMutablePlanView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("=====contentOffset:\(scrollView.contentOffset)==========\n")
        indicatorView.selectedIndex = Int(floor(scrollView.contentOffset.x/scrollView.frame.size.width))
    }
}

extension SSFMutablePlanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell", for: indexPath) as! PlanTableViewCell
        return cell
    }
    
    
}
