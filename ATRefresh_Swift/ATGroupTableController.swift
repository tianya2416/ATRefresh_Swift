//
//  ATGroupTableController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class ATGroupTableController: BaseTableViewController {

    lazy var listData : [ATGroupModel] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: "玄幻")
        self.setupEmpty(scrollView: self.tableView);
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }
    override func refreshData(page: Int) {
        ApiMoya.apiMoyaRequest(target: .apiClassify(page: page, size: RefreshPageSize, group: "male", name: "玄幻"), sucesss: { (json) in
            if page == RefreshPageStart{
                self.listData.removeAll();
            }
            var arrayDatas :[ATGroupModel] = [];
            if let data = [ATGroupModel].deserialize(from: json.rawString()){
                arrayDatas = data as! [ATGroupModel]
            }
            self.listData.append(contentsOf: arrayDatas);
            self.tableView.reloadData();
            self.endRefresh(more: arrayDatas.count >= RefreshPageSize)
        }) { (error) in
            self.endRefreshFailure();
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension;
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TGroupTableViewCell = TGroupTableViewCell.cellForTableView(tableView: tableView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row];
        return cell;
    }
}
