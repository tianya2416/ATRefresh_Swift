//
//  ATGroupTableController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
class ATGroupTableController: BaseTableViewController {

    convenience init(options:ATRefreshOption) {
        self.init();
        self.options = options;
    }
    private var options : ATRefreshOption = .none;
    private lazy var listData : [ATGroupModel] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: "玄幻")
        self.setupRefresh(scrollView: self.tableView, options:self.options);
    }
    
    override func refreshData(page: Int) {
        let size : Int = 20
        
        ApiMoya.apiMoyaRequest(target: .apiClassify(page: page, size: size), sucesss: { (json) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {//看清楚动画
                
                if page == 1{
                    self.listData.removeAll();
                }
                let list = [ATGroupModel].deserialize(from: json["T1348647853363"].rawString()) ?? []
                if let datas = list as? [ATGroupModel]{
                    self.listData.append(contentsOf: datas)
                }
                self.tableView.reloadData()
                self.endRefresh(more: list.count > 0)
            }
        }) { (error) in
            self.endRefreshFailure(error:error);
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
        let cell : ATGroupTableViewCell = ATGroupTableViewCell.cellForTableView(tableView: tableView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row];
        return cell;
    }
}

