//
//  BaseTableViewController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

class BaseTableViewController: BaseRefershController {
    lazy var tableView : UITableView = {
        let tableView : UITableView = UITableView(frame: CGRect.zero, style:.grouped);
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = UITableView.automaticDimension;
        tableView.estimatedRowHeight = 60;
        tableView.keyboardDismissMode = .onDrag;
        tableView.separatorStyle = .none;
        tableView.showsVerticalScrollIndicator = false;
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: NSStringFromClass(UICollectionViewCell.classForCoder()))
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView);
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView.backgroundView?.backgroundColor = UIColor.white;
        self.tableView.backgroundColor = UIColor.white
    }
}
extension BaseTableViewController : UITableViewDataSource,UITableViewDelegate{
    //MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0.01;
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell.init();
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01;
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init();
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init();
    }
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
    }
}
