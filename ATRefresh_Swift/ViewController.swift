//
//  ViewController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class ViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupEmpty(scrollView: self.tableView)
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }
    override func refreshData(page: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.endRefreshFailure();
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
}

