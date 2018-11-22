//
//  SSFMutablePlanView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/7/23.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit
import SwipeCellKit

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
        planTable.dragDelegate = self
        planTable.dragInteractionEnabled = true//By default, on iPad is true,on iPhone is false
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
        planTable.editPlan = { [unowned self] index in self.delegate?.mutablePlanView(self, editePlanAt: index)}
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
}

extension SSFMutablePlanView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dataSource = self.dataSource else { return 0 }
        return dataSource.mutablePlanView(self, numberOfTasksInPlan: (tableView as! PlanTableView).planTableIndex)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell", for: indexPath) as! PlanTableViewCell
        cell.delegate = self
        guard let dataSource = self.dataSource else { return cell }
        let planViewIndex = ((tableView as! PlanTableView).planTableIndex, indexPath.row)
        let dataDic = dataSource.mutablePlanView(self, taskForPlanAt: planViewIndex)
        cell.titleLabel.text = dataDic[.title] as? String
        cell.processLable.text = dataDic[.process] as? String
        cell.checkButton.isSelected = dataDic[.check] as! Bool
        cell.pressCheck = { [unowned self] isSelected in self.delegate?.mutablePlanView(self, didPressTaskCheckAt: planViewIndex, selected: isSelected)}
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let planIndex = (tableView as! PlanTableView).planTableIndex
        self.delegate?.mutablePlanView(self, didSelectTaskAt: (planIndex, indexPath.row))
    }
}

extension SSFMutablePlanView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let result = round(abs(scrollView.contentOffset.x)/scrollView.bounds.width)
        pageControl.currentPage = Int(result)
    }
}
extension SSFMutablePlanView: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let planIndex = (tableView as! PlanTableView).planTableIndex
        let cell = tableView.cellForRow(at: indexPath) as! PlanTableViewCell
        let deleteAction = SwipeAction(style: .destructive, title: "删除") { (action, index) in
            self.delegate?.mutablePlanView(self, deleteTaskAt: (planIndex, index.row))
            cell.hideSwipe(animated: true, completion: nil)
        }
        let addTodayAction = SwipeAction(style: .default, title: "今日做") { (action, index) in
            self.delegate?.mutablePlanView(self, addTaskTodayAt: (planIndex, index.row))
            cell.hideSwipe(animated: true, completion: nil)
        }
        return [deleteAction, addTodayAction]
    }
}

// Provide the data which plan view use to display
protocol SSFMutablePlanViewDataSource: AnyObject {
    func numberOfPlansInMutablePlanView(_ mutablePlanView: SSFMutablePlanView) -> Int
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, numberOfTasksInPlan planIndex: Int) -> Int
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, titleForPlan planIndex: Int) -> String
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, taskForPlanAt indexPath: MutablePlanViewIndex) -> MutablePlanViewCellDic
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, dragTaskForPlanAt indexPath: MutablePlanViewIndex) -> Task
}

//Provide interaction with plan
protocol SSFMutablePlanViewDelegate: AnyObject {
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, creatTaskAt planIndex: Int)
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, deleteTaskAt index: MutablePlanViewIndex)
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, addTaskTodayAt index: MutablePlanViewIndex)
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, editePlanAt planIndex: Int)
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, didSelectTaskAt index: MutablePlanViewIndex)
    func mutablePlanView(_ mutablePlanView: SSFMutablePlanView, didPressTaskCheckAt index: MutablePlanViewIndex, selected: Bool)
}
