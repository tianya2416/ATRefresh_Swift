//
//  ATKeywordController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/11/30.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class ATKeywordController: BaseTableViewController {

    lazy var listData : [String] = {
        return []
    }()
    lazy var textField : UITextField = {
        return UITextField()
    }()
    lazy var searchBtn : UIButton = {
        let button = UIButton.init(type: .custom)
        button.setTitle("搜索", for: .normal)
        button.backgroundColor = UIColor.red
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        return button
    }()
    @objc func searchAction(){
        if self.textField.text!.count > 0 {
            ApiSearchQueue.insertData(keyword: self.textField.text ?? "") { (finish) in
                if (finish){
                    self.refreshData(page: 1)
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.searchBtn)
        self.searchBtn.snp.makeConstraints { (make) in
            make.width.equalTo(60)
            make.height.equalTo(40)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(15)
        }
        self.view.addSubview(self.textField)
        self.textField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(self.searchBtn.snp.left).offset(-10)
            make.height.equalTo(40)
            make.centerY.equalTo(self.searchBtn)
        }
        self.textField.placeholder = "请输入关键词"
        self.textField.layer.masksToBounds = true;
        self.textField.layer.cornerRadius = 5
        self.textField.layer.borderWidth = 1
        self.textField.layer.borderColor = UIColor(hex: "dddddd").cgColor
        self.textField.clearButtonMode = .whileEditing
        
        self.tableView.snp.remakeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.textField.snp.bottom).offset(15)
        }
        self.setupEmpty(scrollView: self.tableView)
        self.setupRefresh(scrollView: self.tableView, options: .none)
    }
    override func refreshData(page: Int) {
        ApiSearchQueue.searchData(page: 1, size: 30) { (listData) in
            if (page == 1){
                self.listData.removeAll()
            }
            self.listData.append(contentsOf: listData)
            self.tableView.reloadData()
            self.endRefresh(more: listData.count >= 30)
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
    }
     func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.listData.count > 0 ? true : false
    }
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let row = UITableViewRowAction.init(style: .default, title: "删除") { (row, inde) in
            let key = self.listData[indexPath.row]
            ApiSearchQueue.deleteData(keywords: [key]) { (finish) in
                if(finish){
                    self.listData.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }
        return [row]
    }
}
class ATFavController: BaseTableViewController {

    lazy var listData : [ATGroupModel] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showNavTitle(title: "收藏夹")
        self.setupEmpty(scrollView: self.tableView,title: "收藏夹空空如也，去收藏数据吧");
        self.setupRefresh(scrollView: self.tableView, options:.defaults);
    }
    
    override func refreshData(page: Int) {
        ApiDataQueue.searchData(page: page,size:20) { (json) in
            if page == 1{
                self.listData.removeAll()
            }
            var datas : [ATGroupModel] = []
            if let data = [ATGroupModel].deserialize(from: json.rawString()){
                datas = data as! [ATGroupModel]
            }
            self.listData.append(contentsOf: datas)
            self.tableView.reloadData()
            self.endRefresh(more: datas.count >= 20)
            
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
        cell.favBtn.isHidden = true
        return cell;
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return self.listData.count > 0 ? true : false
   }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
       let row = UITableViewRowAction.init(style: .default, title: "删除") { (row, inde) in
           let key = self.listData[indexPath.row]
        ApiDataQueue.deleteData(primaryId: key.bookId ?? "") { (finish) in
            if(finish){
                self.listData.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
       }
       return [row]
   }
}
