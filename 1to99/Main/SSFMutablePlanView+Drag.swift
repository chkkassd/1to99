//
//  SSFMutablePlanView+Drag.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/11/14.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import Foundation
import UIKit

extension SSFMutablePlanView: UITableViewDragDelegate {
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let dataSource = self.dataSource else {return []}
        let tableIndex = (tableView as! PlanTableView).planTableIndex
        let task = dataSource.mutablePlanView(self, dragTaskForPlanAt: (tableIndex, indexPath.row))
        let item = UIDragItem(itemProvider: NSItemProvider())
        item.localObject = task
        return [item]
    }
}
