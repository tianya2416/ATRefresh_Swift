//
//  ATViewController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
private let download      = "下拉刷新"
private let upload        = "上拉加载"
private let downandupload = "下拉刷新上拉加载"
private let none          = "不需要下拉刷新上拉加载"

private let gridView = "网格"
private let gridSQL  = "数据库"
class ATViewController: BaseTableViewController {
    lazy var listData : [String] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRefresh(scrollView: self.tableView, options: .defaults);
    }
    override func refreshData(page: Int) {
        debugPrint(page)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.listData = [download,upload,downandupload,none,gridView,gridSQL];
            self.endRefresh(more: false)
            self.tableView.reloadData()
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
        switch str {
        case gridView:
            self.navigationController?.pushViewController(ATGroupConnectionController(), animated:true)
            break
        case gridSQL:
            self.navigationController?.pushViewController(ATSqlController(), animated:true)
            break
        case download:
            UIViewController.rootTopPresentedController().navigationController?.pushViewController(ATGroupTableController(options: [.header,.auto]), animated: true);
            break
        case upload:
            UIViewController.rootTopPresentedController().navigationController?.pushViewController(ATGroupTableController(options: [.footer,.auto]), animated: true);
            break
        case downandupload:
            UIViewController.rootTopPresentedController().navigationController?.pushViewController(ATGroupTableController(options: .defaults), animated: true);
            break
        default:
            UIViewController.rootTopPresentedController().navigationController?.pushViewController(ATGroupTableController(options:[.auto]), animated: true);
            break
        }
    }
}

