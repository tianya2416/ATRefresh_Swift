1、ATRefresh_Swift集成方式:

    pod 'ATRefresh_Swift'
    pod 'ATRefresh_ObjectC'
    
2、ATRefresh_Swift使用方式:

    查看Ddemo
    2、1 无下拉刷新、无上拉加载
    self.setupEmpty(scrollView: self.tableView);
    self.setupRefresh(scrollView: self.tableView, options:.none);
    
    2、2 无下拉刷新、无上拉加载
    self.setupEmpty(scrollView: self.tableView);
    self.setupRefresh(scrollView: self.tableView, options:ATRefreshOption(rawValue: ATRefreshOption.header.rawValue|ATRefreshOption.autoHeader.rawValue));
    
    2、3 无下拉刷新、有上拉加载
    self.setupEmpty(scrollView: self.tableView);
    self.setupRefresh(scrollView: self.tableView, options:ATRefreshOption(rawValue: ATRefreshOption.footer.rawValue|ATRefreshOption.autoFooter.rawValue));
    
    2.4 有下拉刷新、有上拉加载
    self.setupEmpty(scrollView: self.tableView);
    self.setupRefresh(scrollView: self.tableView, options:.defaults);
   
     For Example
     let size : Int = 40;
     ApiMoya.apiMoyaRequest(target: .apiClassify(page: page, size: size, group: "male", name: "玄幻"), sucesss: { (json) in
         DispatchQueue.main.asyncAfter(deadline: .now() + 2) {//看清楚动画
             if page == 1{
                 self.listData.removeAll();
             }
             var arrayDatas :[ATGroupModel] = [];
             if let data = [ATGroupModel].deserialize(from: json.rawString()){
                 arrayDatas = data as! [ATGroupModel]
             }
             self.listData.append(contentsOf: arrayDatas);
             self.tableView.reloadData();
             self.endRefresh(more: arrayDatas.count >= size)
         }
     }) { (error) in
         self.endRefreshFailure();
     }
       
3、ATRefresh_ObjectC版本:
    
[ObjectC版本](https://github.com/tianya2416/ATRefresh_ObjectC.git)
