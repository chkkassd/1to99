//
//  testViewController.swift
//  1to99
//
//  Created by 赛峰 施 on 2018/9/5.
//  Copyright © 2018年 PETER SHI. All rights reserved.
//

import UIKit

class testViewController: UIViewController, UITableViewDataSource, UITableViewDragDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.dragDelegate = self
        tableView.dragInteractionEnabled = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func customEnableDragging(on view: UIView, dragInteractionDelegate: UIDragInteractionDelegate) {
        let dragInteraction = UIDragInteraction(delegate: dragInteractionDelegate)
        view.addInteraction(dragInteraction)
    }
    
    func customEnableDropping(on view: UIView, dropInteractionDelegate: UIDropInteractionDelegate) {
        let dropInteraction = UIDropInteraction(delegate: dropInteractionDelegate)
        view.addInteraction(dropInteraction)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "xxxxidentifier", for: indexPath)
        cell.textLabel?.text = "hahaha"
        return cell
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider(object: "xxx" as NSString))]
    }
}

