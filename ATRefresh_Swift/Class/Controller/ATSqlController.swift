//
//  ATSqlController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/11/30.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class ATSqlController: BaseTableViewController {

    lazy var listData : [String] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: "")
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }
    override func refreshData(page: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.listData = ["关键词","收藏夹"];
            self.endRefresh(more: false);
            self.tableView.reloadData();
    
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = UITableViewCell.cellForTableView(tableView: tableView, indexPath: indexPath);
        cell.textLabel?.text = self.listData[indexPath.row];
        return cell;
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        let str = self.listData[indexPath.row];
        if str == "关键词"{
            self.navigationController?.pushViewController(ATKeywordController(), animated:true)
        }else {
            self.navigationController?.pushViewController(ATFavController(), animated:true)
        }
    }

}
