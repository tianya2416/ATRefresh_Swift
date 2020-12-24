1、ATRefresh_Swift集成方式:

    pod 'ATRefresh_Swift'
    
2、ATRefresh_Swift使用方式:

    
    查看Ddemo
    
    2.1、Create BaseRefershController
    lazy var refreshData: ATRefreshData = {
        let refresh = ATRefreshData()
        refresh.delegate = self
        refresh.dataSource = self
        return refresh
    }()
    
    2.2、implementation delegate and dataSource
    extension BaseRefershController : ATRefreshDataSource{
        var refreshHeaderData: [UIImage] {
            return self.images
        }
        var refreshFooterData: [UIImage] {
            return self.images
        }
        var refreshLogo: UIImage{
            let newImage : UIImage = UIImage.animatedImage(with: self.images, duration: 0.35)!
            let image : UIImage = (self.refreshData.refreshing ? newImage : (self.refreshNetAvailable ? refreshEmptyData : refreshErrorData))
            return image
        }
        var refreshTitle: NSAttributedString{
            let text :String = self.refreshData.refreshing ? refreshLoaderToast : (!self.refreshNetAvailable ? refreshErrorToast : refreshEmptyToast)
            var dic : [NSAttributedString.Key : Any ] = [:]
            let font : UIFont = UIFont.systemFont(ofSize: 16)
            let color : UIColor = UIColor(hex: "666666")
            dic.updateValue(font, forKey: .font)
            dic.updateValue(color, forKey: .foregroundColor)
            let att : NSAttributedString = NSAttributedString(string:"\r\n"+text, attributes:(dic))
            return att
        }
    }
    extension BaseRefershController : ATRefreshDelegate{
        @objc public func refreshData(page:Int){}
    }
    
    2.3、do something BaseRefershController
    
    public func setupRefresh(scrollView:UIScrollView,
                             options:ATRefreshOption,
                             image:UIImage = refreshEmptyData,
                             title:String = refreshEmptyToast){
        refreshEmptyData  = image
        refreshEmptyToast = title
        self.refreshData.setupRefresh(scrollView: scrollView, options: options)
    }
    public func endRefresh(more:Bool){
        self.refreshData.endRefresh(more: more)
    }
    public func endRefreshFailure(error :String? = nil){
        self.refreshData.endRefreshFailure()
    }
    
3、extends BaseRefershController 
    
    3、1 无下拉刷新、无上拉加载
    self.setupRefresh(scrollView: self.tableView, options:.none);
    
    3、2 有下拉刷新、无上拉加载
    self.setupRefresh(scrollView: self.tableView, options:ATRefreshOption(rawValue: ATRefreshOption.header.rawValue|ATRefreshOption.autoHeader.rawValue));
    
    3、3 无下拉刷新、有上拉加载
    self.setupRefresh(scrollView: self.tableView, options:ATRefreshOption(rawValue: ATRefreshOption.footer.rawValue|ATRefreshOption.autoFooter.rawValue));
    
    3.4 有下拉刷新、有上拉加载
    self.setupRefresh(scrollView: self.tableView, options:.defaults);
    
    override func refreshData(page: Int) {
        let size : Int = 20
        ApiMoya.apiMoyaRequest(target: .apiClassify(page: page, size: size, group: "male", name: "玄幻"), sucesss: { (json) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {//看清楚动画
                
                if page == 1{
                    self.listData.removeAll();
                }
                var arrayDatas :[ATGroupModel] = [];
                if let data = [ATGroupModel].deserialize(from: json.rawString()){
                    print(data.count)
                    arrayDatas = data as! [ATGroupModel]
                }
                self.listData.append(contentsOf: arrayDatas);
                self.tableView.reloadData()
                self.endRefresh(more: arrayDatas.count > 0)
            }
        }) { (error) in
            self.endRefreshFailure(error:error);
        }
    }
       
4、ATRefresh_ObjectC版本:
    
[ObjectC版本](https://github.com/tianya2416/ATRefresh_ObjectC.git)
