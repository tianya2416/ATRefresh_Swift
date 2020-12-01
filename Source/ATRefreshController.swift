//
//  BaseRefreshController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//
import UIKit
private let at_refresh_navi = ATRefresh.Navi_Bar()
private let RefreshPageStart : Int = (1)

open class ATRefreshController: UIViewController {
    
    weak open var scrollView : UIScrollView!
    weak open var dataSource : ATRefreshDataSource? = nil
    
    private var reachable: Bool = ATRefresh.reachable()
    
    private var headerImages  : [UIImage]{
        get{
            return self.dataSource?.refreshHeaderData ?? []
        }
    }
    private var footerImages  : [UIImage]{
        get{
            return (self.dataSource?.refreshFooterData) ?? []
        }
    }
    private var loadImages    : UIImage{
        get{
            let images = (self.dataSource?.refreshLoaderData) ?? []
            return UIImage.animatedImage(with: images, duration: 0.35)!
        }
    }
    private var errorImage    : UIImage{
        get{
            return self.dataSource?.refreshErrorData ?? UIImage.init()
        }
    }
    private var _emptyImage   : UIImage?
    private var emptyImage    : UIImage{
        get{
            return _emptyImage ?? (self.dataSource?.refreshEmptyData ?? UIImage.init())
        }set{
            _emptyImage = newValue
        }
    }
    private var _emptyToast   : String?
    private var emptyToast    : String{
        get{
            return _emptyToast ?? (self.dataSource?.refreshEmptyToast ?? "Data Empty...")
        }set{
            _emptyToast = newValue
        }
    }
    private var errorToast    : String{
        get{
            return self.dataSource?.refreshErrorToast ?? "Net Error..."
        }
    }
    private var loadToast     : String{
        get{
            return self.dataSource?.refreshLoaderToast ?? "Data Loading..."
        }
    }
    private var currentPage   : Int = 0
    private var isSetKVO      : Bool = false
    private var _refreshing : Bool = false
    private var refreshing  : Bool{
        set{
            _refreshing = newValue
            if self.scrollView != nil {
                if self.scrollView!.isEmptyDataSetVisible {
                    self.reloadEmptyData()
                }
            }
        }get{
            return _refreshing
        }
    }
    deinit {
        print(self.classForCoder,"is deinit")
    }
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:设置刷新控件 子类可在refreshData中发起网络请求, 请求结束后回调endRefresh结束刷新动作
    /**
    @brief 设置刷新控件 子类可在refreshData中发起网络请求, 请求结束后回调endRefresh结束刷新动作
    @param scrollView 刷新控件所在scrollView
    @param option 刷新空间样式
    */
    open func setupRefresh(scrollView:UIScrollView,options:ATRefreshOption){
        self.scrollView = scrollView
        if options.rawValue == 0{
            //无下拉上拉
            self.headerRefreshing()
        }
        if options.rawValue & ATRefreshOption.header.rawValue == 1  {
            //需要下拉刷新
            let header : MJRefreshGifHeader = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(headerRefreshing))
            header.stateLabel?.isHidden = true
            header.isAutomaticallyChangeAlpha = true
            header.lastUpdatedTimeLabel?.isHidden = true
            if self.headerImages.count > 0 {
                header.setImages([self.headerImages.first as Any], for: .idle)
                header.setImages(self.headerImages, duration: 0.35, for: .refreshing)
            }
            if options.rawValue & ATRefreshOption.autoHeader.rawValue == 4 {
                self.headerRefreshing()
            }
            scrollView.mj_header = header
        }
        if (options.rawValue & ATRefreshOption.footer.rawValue) == 2 {
            //需要上拉加载
            let footer : MJRefreshAutoGifFooter = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(footerRefreshing))
            footer.triggerAutomaticallyRefreshPercent = 1
            footer.stateLabel?.isHidden = false
            footer.labelLeftInset = -22
            if self.footerImages.count > 0 {
                footer.setImages([self.footerImages.first as Any], for: .idle)
                footer.setImages(self.footerImages, duration: 0.35, for: .refreshing)
            }
            footer.setTitle(" —— 我是有底线的 ——  ", for: .noMoreData)
            footer.setTitle("", for: .pulling)
            footer.setTitle("", for: .refreshing)
            footer.setTitle("", for: .willRefresh)
            footer.setTitle("", for: .idle)
            footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
            if options.rawValue & ATRefreshOption.autoFooter.rawValue == 8 {
                self.footerRefreshing()
            }
            scrollView.mj_footer = footer
        }
    }
    //MARK:设置空界面显示, 如果需要定制化
    /**
    设置空界面显示, 如果需要定制化 请实现协议 DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
    tableView或者CollectionView数据reload后, 空界面展示可自动触发, 如需强制刷新, 请调用 [scrollView reloadEmptyDataSet]
    
    @param scrollView 空界面所在scrollView
    @param image 空界面图片
    @param title 空界面标题
    */
    open func setupEmpty(scrollView:UIScrollView){
        self.setupEmpty(scrollView: scrollView, image:nil, title:nil)
    }
    open func setupEmpty(scrollView:UIScrollView,image:UIImage? = nil,title:String? = nil){
        scrollView.emptyDataSetSource = self
        scrollView.emptyDataSetDelegate = self
        if title != nil {
            self.emptyToast = title!
        }
        if image != nil {
            self.emptyImage = image!
        }
        if self.isSetKVO {
            return
        }
        self.isSetKVO = true
        weak var weakSelf = self
        self.kvoController.observe(scrollView, keyPaths: ["contentSize","contentInset"], options: .new) { (observer, object, change) in
            NSObject.cancelPreviousPerformRequests(withTarget:weakSelf as Any, selector: #selector(weakSelf!.reloadEmptyData), object:nil)
            weakSelf!.perform(#selector(weakSelf!.reloadEmptyData), with:nil, afterDelay: 0.01)
        }
    }
    //MARK:分页请求一开始page = 1
    /**
    @brief 分页请求一开始page = 1
    @param page 当前页码
    */
    open func refreshData(page:Int){
        self.currentPage = page
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            guard let scrollView = self.scrollView else { return }
            guard let mj_header = scrollView.mj_header else { return }
            mj_header.isRefreshing ? self.endRefreshFailure() : nil
        }
    }
    //MARK:加载成功 是否有下一页数据
    /**
    @brief 分页加载成功 是否有下一页数据
    */
    open func endRefresh(more:Bool){
        self.baseEndRefreshing()
        guard let scrollView = self.scrollView else { return }
        guard let mj_footer = scrollView.mj_footer else { return }
        if more {
            mj_footer.state = .idle
            mj_footer.isHidden = false
            if mj_footer is MJRefreshAutoStateFooter{
                let footer:MJRefreshAutoStateFooter = mj_footer as! MJRefreshAutoStateFooter
                footer.stateLabel?.textColor = UIColor(hex: "666666")
                footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
            }
        }else{
            mj_footer.state = .noMoreData
            if mj_footer is  MJRefreshAutoStateFooter{
                let footer:MJRefreshAutoStateFooter = mj_footer as! MJRefreshAutoStateFooter
                footer.stateLabel?.textColor = UIColor(hex: "999999")
                footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
            }
            DispatchQueue.main.asyncAfter(deadline:.now()+0.01) {
                let height : CGFloat = (scrollView.contentSize.height)
                let sizeHeight : CGFloat = (scrollView.frame.size.height)
                let res : Bool = (self.currentPage == RefreshPageStart) || (height < sizeHeight)
                mj_footer.isHidden = res
            }
        }
    }
    //MARK:加载失败
    open func endRefreshFailure(error :String? = nil){
        if error != nil {
            self.emptyToast = error ?? ""
        }
        if self.currentPage > RefreshPageStart {
            self.currentPage = self.currentPage - 1
        }
        self.baseEndRefreshing()
        self.reloadEmptyData()
        guard let scrollView = self.scrollView else { return }
        guard let mj_footer = scrollView.mj_header else { return }
        mj_footer.isRefreshing ? mj_footer.state = .idle : nil
    }
    /**
    @brief 加载第一页
    */
    @objc open func headerRefreshing(){
        if self.refreshing == false {
            self.refreshing = true
            self.currentPage = RefreshPageStart
            self.refreshData(page: self.currentPage)
        }
    }
    @objc open func footerRefreshing(){
        if self.refreshing == false {
            self.refreshing = true
            self.currentPage = self.currentPage + 1
            self.refreshData(page: self.currentPage)
        }
    }
    final func baseEndRefreshing(){
        self.refreshing = false
        guard let scrollView = self.scrollView else { return }
        guard let mj_header = scrollView.mj_header else { return }
        mj_header.isRefreshing ? mj_header.endRefreshing() : nil
    }
    @objc final func reloadEmptyData(){
        guard let scrollView = self.scrollView else { return }
        scrollView.reloadEmptyDataSet()
    }

}
extension ATRefreshController :DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    //MARK:DZNEmptyDataSetSource
    open func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text :String = self.refreshing ? self.loadToast : (!self.reachable ? self.errorToast : self.emptyToast)
        var dic : [NSAttributedString.Key : Any ] = [:]
        let font : UIFont = UIFont.systemFont(ofSize: 15)
        let color : UIColor = UIColor(hex: "999999")
        dic.updateValue(font, forKey: .font)
        dic.updateValue(color, forKey: .foregroundColor)
        let att : NSAttributedString = NSAttributedString(string:"\r\n"+text, attributes:(dic))
        return att
    }
    open func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return nil
    }
    open func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        let image : UIImage = (self.refreshing ? self.loadImages : (self.reachable ? self.emptyImage : self.errorImage))
        return image
    }
    open func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    open func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return -(at_refresh_navi)/2
    }
    open func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 1
    }
    open func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    open func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    open func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return !self.refreshing
    }
    open func emptyDataSet(_ scrollView: UIScrollView!, didTap view: UIView!) {
        self.refreshing ? nil : self.headerRefreshing()
    }

}
