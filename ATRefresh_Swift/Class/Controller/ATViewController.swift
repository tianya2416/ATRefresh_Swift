//
//  ATViewController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
//  pod lib lint ATRefresh_Swift.podspec  --allow-warnings --sources='https://github.com/CocoaPods/Specs.git'
//pod trunk push --allow-warnings --sources='https://github.com/CocoaPods/Specs.git'
//  pod trunk push ATRefresh_Swift.podspec  --allow-warnings --sources='https://github.com/CocoaPods/Specs.git'
class ATViewController: BaseTableViewController {
    lazy var listData : [String] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }
    override func refreshData(page: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.listData = ["下拉刷新","上拉加载","上拉下拉","无上下拉","ConnectionView","SQLite"];
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
        if str == "ConnectionView"{
            self.navigationController?.pushViewController(ATGroupConnectionController(), animated:true)
        }else if str == "SQLite"{
            self.navigationController?.pushViewController(ATSqlController(), animated:true)
        }
        else{
            var options : ATRefreshOption = .none;
            if str == "下拉刷新" {
                options = ATRefreshOption(rawValue: ATRefreshOption.header.rawValue|ATRefreshOption.autoHeader.rawValue);
            }else if str == "上拉加载"{
                options = ATRefreshOption(rawValue: ATRefreshOption.footer.rawValue|ATRefreshOption.autoFooter.rawValue);
            }else if str == "上拉下拉"{
                options = .defaults;
            }else{
                options = .none;
            }
        UIViewController.rootTopPresentedController().navigationController?.pushViewController(ATGroupTableController(options: options), animated: true);
        }
    }
}

