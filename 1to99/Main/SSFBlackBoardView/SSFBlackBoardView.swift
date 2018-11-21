//
//  SSFBlackBoardView.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/11/21.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

enum BlackBoardViewUpdateModel {
    case insert
    case delet
}

class SSFBlackBoardView: UIView {

    @IBOutlet var containView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var dataSource: SSFBlackBoardViewDatasource?

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
        Bundle.main.loadNibNamed("BlackBoardView", owner: self, options: nil)
        containView.frame = self.bounds
        containView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(containView)
        configureCollectionView()
    }
    
    // MARK: Private methods
    private func configureCollectionView() {
        let nib = UINib(nibName: "BlackBoardCollectionViewCell", bundle: Bundle.main)
        collectionView.register(nib, forCellWithReuseIdentifier: "BlackBoardCollectionViewCell")
        collectionView.dataSource = self
        collectionView.dropDelegate = self
    }
}

extension SSFBlackBoardView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datasource = self.dataSource else {return 0}
        return datasource.numberOfItems(in: self)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BlackBoardCollectionViewCell", for: indexPath) as! BlackBoardCollectionViewCell
        return cell
    }
}

protocol SSFBlackBoardViewDatasource: AnyObject {
    func numberOfItems(in blackBoardView: SSFBlackBoardView) -> Int
    func blackBoardView(_ blackBoardView: SSFBlackBoardView, updateDataSourceAt index: Int, updateModel: BlackBoardViewUpdateModel, updatedData: Task)
}
