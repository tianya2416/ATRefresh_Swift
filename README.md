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
   
     [ATTool getData:@"https://api.zhuishushenqi.com/book/by-categories" params:params success:^(id  _Nonnull object) {
            if (page == 1) {
                [self.listData removeAllObjects];
            }
            NSArray *datas = [NSArray modelArrayWithClass:ATModel.class json:object];
            if (datas.count > 0) {
                [self.listData addObjectsFromArray:datas];
            }
            [self.tableView reloadData];
            
            [self endRefresh:datas.count >= count];//判断是否有下一页
       } failure:^(NSError * _Nonnull error) {
       
            [self endRefreshFailure];
       }];
       
3、ATRefresh_ObjectC版本:
    
[Swift版本](https://github.com/tianya2416/ATRefresh_ObjectC.git)
