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
    @IBOutlet weak var indicatorView: IndicatorView!
    @IBOutlet weak var planCollectionView: UICollectionView!
    var allPlanTables: [PlanTableView] = []
    
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
        //1.load nib
        Bundle.main.loadNibNamed("MainPlanView", owner: self, options: nil)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(containView)
        //2.set collectionview
        configureCollectionView()
        
        
        indicatorView.count = allPlanTables.count

        
    }
    // MARK: Private method
    
    

    
    // MARK: Public API
    
    public func configureCollectionView() {
        let collectionCellNib = UINib(nibName: "PlanCollectionViewCell", bundle: Bundle.main)
        planCollectionView.register(collectionCellNib, forCellWithReuseIdentifier: "PlanCollectionViewCell")
        planCollectionView.delegate = self
        planCollectionView.dataSource = self
    }
    
    public func creatAPlanTable() -> PlanTableView {
        let planTable = PlanTableView.getAPlanTableView()
        let cellNib = UINib(nibName: "PlanTableViewCell", bundle: Bundle.main)
        planTable.register(cellNib, forCellReuseIdentifier: "PlanTableViewCell")
        planTable.delegate = self
        planTable.dataSource = self
        
       
        allPlanTables.append(planTable)
        
        return planTable
    }
    
    public func addTaskInPlanTable() {
        
    }
}

extension SSFMutablePlanView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanCollectionViewCell", for: indexPath) as! PlanCollectionViewCell
        
        let cellNib = UINib(nibName: "PlanTableViewCell", bundle: Bundle.main)
        cell.planTable.register(cellNib, forCellReuseIdentifier: "PlanTableViewCell")
        cell.planTable.delegate = self
        cell.planTable.dataSource = self
        cell.planTable.reloadData()

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.bounds.width - (collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
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
