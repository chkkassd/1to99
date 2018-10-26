//
//  SSFMutablePlanView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/23.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

typealias MutablePlanViewIndex = (Int, Int)//first para is plan index, second para is task index

typealias MutablePlanViewCellDic = [MutablePlanViewCellDicKey : Any]

enum MutablePlanViewCellDicKey {
    case title
    case process
    case check
}

class SSFMutablePlanView: UIView {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet var containView: UIView!
    @IBOutlet weak var planCollectionView: UICollectionView!
    var allPlanTables: [PlanTableView] = []
    
    weak var dataSource: SSFMutablePlanViewDataSource? {
        didSet {
            pageControl.numberOfPages = dataSource?.numberOfPlansInMutablePlanView(self) ?? 0
        }
    }
    
    weak var delegate: SSFMutablePlanViewDelegate?
    
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
    }
    
    // MARK: Private method
    private func configureCollectionView() {
        let collectionCellNib = UINib(nibName: "PlanCollectionViewCell", bundle: Bundle.main)
        planCollectionView.register(collectionCellNib, forCellWithReuseIdentifier: "PlanCollectionViewCell")
        planCollectionView.delegate = self
        planCollectionView.dataSource = self
    }
    
    private func creatAPlanTable() -> PlanTableView {
        let planTable = PlanTableView.getAPlanTableView()
        let cellNib = UINib(nibName: "PlanTableViewCell", bundle: Bundle.main)
        planTable.register(cellNib, forCellReuseIdentifier: "PlanTableViewCell")
        planTable.delegate = self
        planTable.dataSource = self
        return planTable
    }
    
    // MARK: Public API
    public func creatPlanView(at item: Int) {
        let indexPath = IndexPath(item: item, section: 0)
        planCollectionView.insertItems(at: [indexPath])
        pageControl.numberOfPages += 1
    }
    
    public func removePlanView(at item: Int) {
        let indexPath = IndexPath(item: item, section: 0)
        planCollectionView.deleteItems(at: [indexPath])
        pageControl.numberOfPages -= 1
    }
    
    public func reloadMutablePlanView() {
        self.planCollectionView.reloadData()
    }
    
    public func updatePageControl(_ deletions: [Int], _ insertions: [Int]) {
        let num = insertions.count - deletions.count
        pageControl.numberOfPages += num
    }
    
    public func addTaskInPlanTable() {
        
    }
    
    public func removeTaskInPlanTable() {
        
    }
}

extension SSFMutablePlanView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    //datasource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else { return 0 }
        return dataSource.numberOfPlansInMutablePlanView(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlanCollectionViewCell", for: indexPath) as! PlanCollectionViewCell
        guard let dataSource = self.dataSource else { return cell }
        //clear subview
        cell.contentView.subviews.forEach {$0.removeFromSuperview()}
        //add subview
        let planTable = creatAPlanTable()
        planTable.planTableIndex = indexPath.row
        planTable.planTitle.text = dataSource.mutablePlanView(self, titleForPlan: indexPath.item)
        planTable.creatTask = { [unowned self] index in self.delegate?.mutablePlanView(self, creatTaskAt: index)}
        planTable.editPlan = { index in }
        planTable.renamePlan = { index in }
        cell.contentView.addSubview(planTable)
        //layout subview
        planTable.translatesAutoresizingMaskIntoConstraints = false
        let collectionCellSafeArea = cell.safeAreaLayoutGuide
        planTable.topAnchor.constraint(equalTo: collectionCellSafeArea.topAnchor).isActive = true
        planTable.bottomAnchor.constraint(equalTo: collectionCellSafeArea.bottomAnchor).isActive = true
        planTable.leadingAnchor.constraint(equalTo: collectionCellSafeArea.leadingAnchor).isActive = true
        planTable.trailingAnchor.constraint(equalTo: collectionCellSafeArea.trailingAnchor).isActive = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 40.0
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
    
    //delegate

}

extension SSFMutablePlanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else { return 0 }
        return dataSource.mutablePlanView(self, numberOfTasksInPlan: (tableView as! PlanTableView).planTableIndex)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell", for: indexPath) as! PlanTableViewCell
        guard let dataSource = self.dataSource else { return cell }
        let dataDic = dataSource.mutablePlanView(self, taskForPlanAt: ((tableView as! PlanTableView).planTableIndex, indexPath.row))
        cell.titleLabel.text = dataDic[.title] as? String
        cell.processLable.text = dataDic[.process] as? String
        cell.checkButton.isSelected = dataDic[.check] as! Bool
        return cell
    }
    
//    //edite model
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return UITableViewCell.EditingStyle.delete
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.delegate?.mutablePlanView(self, deleteTaskAt: ((tableView as! PlanTableView).planTableIndex, indexPath.row))
//        }
//    }
//
//    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
//        return "删除任务"
//    }
}

extension SSFMutablePlanView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let result = round(abs(scrollView.contentOffset.x)/scrollView.bounds.width)
        pageControl.currentPage = Int(result)
    }
}

// Provide the data which plan view use to display
protocol SSFMutablePlanViewDataSource: AnyObject {
    func numberOfPlansInMutablePlanView(_ mutablePlanView: SSFMutablePlanView) -> Int
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, numberOfTasksInPlan planIndex: Int) -> Int
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, titleForPlan planIndex: Int) -> String
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, taskForPlanAt indexPath: MutablePlanViewIndex) -> MutablePlanViewCellDic
}

//Provide interaction with plan
protocol SSFMutablePlanViewDelegate: AnyObject {
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, creatTaskAt planIndex: Int)
//    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, deleteTaskAt index: MutablePlanViewIndex)
}
