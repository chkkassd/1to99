//
//  SSFBlackBoardView+Drop.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/11/21.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import Foundation
import UIKit

extension SSFBlackBoardView: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .cancel, intent: .unspecified)
        } else if session.localDragSession != nil {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .forbidden, intent: .unspecified)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let task = coordinator.items.first?.dragItem.localObject as? Task else {return}
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let item = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(item: item, section: 0)
        }
        self.dataSource?.blackBoardView(self, updateDataSourceAt: destinationIndexPath, updateModel: .insert, updatedData: task)
        }
    }

