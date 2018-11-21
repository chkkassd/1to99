//
//  SSFPlanViewController+Drop.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/11/14.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import Foundation
import UIKit

extension SSFPlanViewController: UIDropInteractionDelegate {
    func customEnableDropping(on view: UIView, dropInteractionDelegate: UIDropInteractionDelegate) {
        let dropInteraction = UIDropInteraction(delegate: dropInteractionDelegate)
        view.addInteraction(dropInteraction)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        if (session.localDragSession) != nil {
            return UIDropProposal(operation: .copy)
        } else {
            return UIDropProposal(operation: .forbidden)
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        guard let locaDrag = session.localDragSession else {return}
        let task = locaDrag.items.first?.localObject as! Task
    }
}
