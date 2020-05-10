//
//  BaseRefreshController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import Alamofire

class ATRefreshController: ATViewController {
    weak open var scrollView : UIScrollView!;
    weak open var dataSource : ATRefreshDataSource? = nil;
    public var reachable: Bool{
        get{
            return NetworkReachabilityManager.init()!.isReachable;
        }
    }
    private var headerImages  : [UIImage]{
        get{
            return (self.dataSource?.refreshHeaderData()) ?? [];
        }
    }
    private var footerImages  : [UIImage]{
        get{
            return (self.dataSource?.refreshFooterData()) ?? [];
        }
    }
    private var loadImages    : UIImage{
        get{
            return (self.dataSource?.refreshLoaderData()) ?? UIImage.init();
        }
    }
    private var noNetImage    : UIImage{
        get{
            return self.dataSource?.refreshNoNetData() ?? UIImage.init();
        }
    }
    private var emptyImage    : UIImage? = UIImage.init();
    private var _emptyToast   : String!
    private var emptyToast    : String{
        get{
            return (_emptyToast != nil) ?_emptyToast :(self.dataSource?.refreshEmptyDataToast?() ?? "数据空空如也...")
        }set{
            
        }
    }
    private var noNetToast    : String{
        get{
            return self.dataSource?.refreshNoNetDataToast?() ?? "无网络连接,请检查网络设置..."
        }
    }
    
    private var loadToast     : String{
        get{
            return self.dataSource?.refreshLoadingDataToast?() ?? "数据加载中..."
        }
    }
    private var currentPage   : Int = 0;
    private var isSetKVO      : Bool = false;
    private var _isRefreshing : Bool = false;
    private var isRefreshing : Bool{
        set{
            _isRefreshing = newValue;
            if self.scrollView != nil {
                if self.scrollView!.isEmptyDataSetVisible {
                    self.reloadEmptyData();
                }
            }
        }get{
            return _isRefreshing;
        }
    }
    deinit {
//        self.scrollView.delegate = nil;
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /**
    @brief 设置刷新控件 子类可在refreshData中发起网络请求, 请求结束后回调endRefresh结束刷新动作
    @param scrollView 刷新控件所在scrollView
    @param option 刷新空间样式
    */
    final func setupRefresh(scrollView:UIScrollView,options:ATRefreshOption){
        self.scrollView = scrollView;
        if options.rawValue == ATRefreshOption.none.rawValue {
            if self.responds(to: #selector(headerRefreshing)) {
                self.headerRefreshing();
            }
            return;
        }
        var value : Int = options.rawValue & ATRefreshOption.header.rawValue;
        if value == 1  {
            let header : MJRefreshGifHeader = MJRefreshGifHeader.init(refreshingTarget: self, refreshingAction: #selector(headerRefreshing));
            header.stateLabel.isHidden = true;
            header.isAutomaticallyChangeAlpha = true;
            header.lastUpdatedTimeLabel.isHidden = true;
            if self.headerImages.count > 0 {
                header.setImages([self.headerImages.first as Any], for: .idle);
                header.setImages(self.headerImages, duration: 0.35, for: .refreshing);
            }
            value = options.rawValue & ATRefreshOption.autoHeader.rawValue;
            if value == 4 {
                self.headerRefreshing();
            }
            scrollView.mj_header = header;
        }
        value = options.rawValue & ATRefreshOption.footer.rawValue;
        if value == 2 {
            let footer : MJRefreshAutoGifFooter = MJRefreshAutoGifFooter.init(refreshingTarget: self, refreshingAction: #selector(footerRefreshing));
            footer.triggerAutomaticallyRefreshPercent = -20;
            footer.stateLabel.isHidden = false;
            footer.labelLeftInset = -22;
            if self.footerImages.count > 0 {
                footer.setImages([self.footerImages.first as Any], for: .idle);
                footer.setImages(self.footerImages, duration: 0.35, for: .refreshing);
            }
            footer.setTitle(" —— 我是有底线的 ——  ", for: .noMoreData);
            footer.setTitle("", for: .pulling);
            footer.setTitle("", for: .refreshing);
            footer.setTitle("", for: .willRefresh);
            footer.setTitle("", for: .idle);
            footer.stateLabel.font = UIFont.systemFont(ofSize: 14)
            value = options.rawValue & ATRefreshOption.autoFooter.rawValue;
            if value == 8 {
                if self.currentPage == 0 {
                    self.isRefreshing = true;
                }
                self.footerRefreshing();
            }
            value = options.rawValue & ATRefreshOption.defaultHidden.rawValue;
            if value == 16 {
                footer.isHidden = true
            }
            scrollView.mj_footer = footer;
        }
        
    }
    /**
    设置空界面显示, 如果需要定制化 请实现协议 DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
    tableView或者CollectionView数据reload后, 空界面展示可自动触发, 如需强制刷新, 请调用 [scrollView reloadEmptyDataSet];
    
    @param scrollView 空界面所在scrollView
    @param image 空界面图片
    @param title 空界面标题
    */
    final func setupEmpty(scrollView:UIScrollView){
        self.setupEmpty(scrollView: scrollView, image:nil, title:nil)
    }
    final func setupEmpty(scrollView:UIScrollView,image:UIImage? = nil,title:String? = nil){
        scrollView.emptyDataSetSource = self;
        scrollView.emptyDataSetDelegate = self;
        self.emptyImage = (image != nil) ?image!: (self.dataSource?.refreshEmptyData() ?? UIImage.init());
        if title != nil {
            self.emptyToast = title!;
        }
        if self.isSetKVO {
            return;
        }
        self.isSetKVO = true;
        weak var weakSelf = self;
        self.kvoController.observe(scrollView, keyPaths: ["contentSize","contentInset"], options: .new) { (observer, object, change) in
            NSObject.cancelPreviousPerformRequests(withTarget:weakSelf as Any, selector: #selector(weakSelf!.reloadEmptyData), object:nil)
            weakSelf!.perform(#selector(weakSelf!.reloadEmptyData), with:nil, afterDelay: 0.01)
        };
    }
    /**
    @brief 分页请求一开始page = 1
    @param page 当前页码
    */
    public func refreshData(page:Int){
        self.currentPage = page;
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            if self.scrollView.mj_header != nil{
                if (self.scrollView?.mj_header.isRefreshing)! || (self.scrollView?.mj_header.isRefreshing)!{
                    self.endRefreshFailure();
                }
            }
        }
    }
    /**
    @brief 分页加载成功 是否有下一页数据
    */
    final func endRefresh(more:Bool){
        self.baseEndRefreshing();
        if self.scrollView.mj_footer == nil {
            return;
        }
        if more {
            self.scrollView?.mj_footer.state = .idle;
            self.scrollView?.mj_footer.isHidden = false;
            let footer:MJRefreshAutoStateFooter = self.scrollView?.mj_footer as! MJRefreshAutoStateFooter;
            footer.stateLabel.textColor = UIColor.init(hex: "666666");
            footer.stateLabel.font = UIFont.systemFont(ofSize: 14)
        }else{
            self.scrollView?.mj_footer.state = .noMoreData;
            let footer:MJRefreshAutoStateFooter = self.scrollView?.mj_footer as! MJRefreshAutoStateFooter;
            footer.stateLabel.textColor = UIColor.init(hex: "999999");
            footer.stateLabel.font = UIFont.systemFont(ofSize: 14)
            DispatchQueue.main.asyncAfter(deadline:.now()+0.01) {
                let height : CGFloat = (self.scrollView?.contentSize.height)!;
                let sizeHeight : CGFloat = (self.scrollView?.frame.size.height)!;
                let res : Bool = (self.currentPage == RefreshPageStart) || (height < sizeHeight);
                self.scrollView?.mj_footer.isHidden = res;
            }
        }
    }
    final func endRefreshFailure(){
        if self.currentPage > RefreshPageStart {
            self.currentPage = self.currentPage - 1;
        }
        self.baseEndRefreshing();
        if self.scrollView.mj_footer != nil {
                    if (self.scrollView?.mj_footer.isRefreshing)! {
                self.scrollView?.mj_footer.state = .idle;
            }
        }
        self.reloadEmptyData();
        
    }
    /**
    @brief 重新加载第一页
    */
    @objc final func headerRefreshing(){
        self.isRefreshing = true;
        if self.scrollView.mj_footer != nil{
            self.scrollView?.mj_footer.isHidden = true;
        }
        self.currentPage = RefreshPageStart;
        self.refreshData(page: self.currentPage);
    }
    @objc final func footerRefreshing(){
        self.currentPage = self.currentPage + 1;
        self.refreshData(page: self.currentPage);
    }
    final func baseEndRefreshing(){
        if self.scrollView.mj_header != nil {
            if (self.scrollView?.mj_header.isRefreshing)! {
                self.scrollView?.mj_header.endRefreshing();
            }
        }
        self.isRefreshing = false;
    }
    @objc final func reloadEmptyData(){
        if self.scrollView != nil {
            self.scrollView?.reloadEmptyDataSet();
        }
    }

}
extension ATRefreshController :DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    //MARK:DZNEmptyDataSetSource
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        var text :String = self.isRefreshing ? self.loadToast : self.emptyToast;
        var dic : [NSAttributedString.Key : Any ] = [:];
        let font : UIFont = UIFont.systemFont(ofSize: 15);
        let color : UIColor = UIColor.init(hex: "999999")
        dic.updateValue(font, forKey: .font);
        dic.updateValue(color, forKey: .foregroundColor)
        if self.reachable == false {
            text = self.noNetToast;
        }
        let att : NSAttributedString = NSAttributedString.init(string:"\r\n"+text, attributes:(dic));
        return att;
    }
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return nil;
    }
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let image : UIImage = (self.isRefreshing ? self.loadImages : self.emptyImage)!;
        return self.reachable ? image : self.dataSource?.refreshNoNetData();
    }
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return false;
    }
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -NAVI_BAR_HIGHT/2
    }
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 1;
    }
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true;
    }
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true;
    }
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return !self.isRefreshing;
    }
    func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        if self.isRefreshing == false {
            self.headerRefreshing();
        }
    }
}
