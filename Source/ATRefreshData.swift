//
//  BaseRefreshController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/30.
//  Copyright © 2019 wangws1990. All rights reserved.
//
import UIKit
import EmptyDataSet_Swift

public class ATRefreshData: NSObject {
    public weak var dataSource :ATRefreshDataSource? = nil
    public weak var delegate   :ATRefreshDelegate? = nil
    public var refreshing  :Bool{
        set{
            _refreshing = newValue
            self.reloadEmptyData()
        }get{
            return _refreshing
        }
    }
    //MARK:refreshing 有动画
    public func beginRefreshing(){
        guard let scrollView = self.scrollView,let mj_header = scrollView.mj_header  else { return }
        mj_header.beginRefreshing()
    }
    private weak var scrollView :UIScrollView? = nil
    private var currentPage :Int = 0
    private var _refreshing :Bool = false
    
    
    //MARK:设置刷新控件 子类可在refreshData中发起网络请求, 请求结束后回调endRefresh结束刷新动作
    public func setupRefresh(scrollView:UIScrollView,options:ATRefreshOption){
        scrollView.emptyDataSetSource = self
        scrollView.emptyDataSetDelegate = self
        self.scrollView = scrollView
        if options.rawValue & ATRefreshOption.header.rawValue != 0 {//需要下拉刷新
            let header  = MJRefreshGifHeader(refreshingTarget: self, refreshingAction: #selector(headerRefreshing))
            if let headerImages = self.dataSource?.refreshHeaderData {
                if headerImages.count > 0 {
                    header.setImages([headerImages.first as Any], for: .idle)
                    header.setImages(headerImages, duration: 0.35, for: .refreshing)
                    header.stateLabel?.isHidden = true
                    header.isAutomaticallyChangeAlpha = true
                    header.lastUpdatedTimeLabel?.isHidden = true
                }
            }
            scrollView.mj_header = header
        }
        if options.rawValue & ATRefreshOption.footer.rawValue != 0{//需要上拉加载
            let footer  = MJRefreshAutoGifFooter(refreshingTarget: self, refreshingAction: #selector(footerRefreshing))
            footer.triggerAutomaticallyRefreshPercent = 1
            footer.stateLabel?.isHidden = false
            footer.labelLeftInset = -22
            footer.setTitle("", for: .idle)
            if let footerImages = self.dataSource?.refreshFooterData {
                if footerImages.count > 0 {
                    footer.setImages([footerImages.first as Any], for: .idle)
                    footer.setImages(footerImages, duration: 0.35, for: .refreshing)
                    footer.setTitle(" —— 我是有底线的 ——  ", for: .noMoreData)
                    footer.setTitle("", for: .pulling)
                    footer.setTitle("", for: .refreshing)
                    footer.setTitle("", for: .willRefresh)
                    footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
                }
            }
            scrollView.mj_footer = footer
        }
        if options.rawValue & ATRefreshOption.auto.rawValue != 0{//无下拉上拉
            self.headerRefreshing()
        }
    }
    //MARK:分页请求一开始page = 1
    public func refreshData(page:Int){
        guard let delegate = self.delegate else { return }
        delegate.refreshData(page: page)
        self.currentPage = page
    }
    //MARK:加载成功 是否有下一页数据
    public func endRefresh(more:Bool){
        self.baseEndRefreshing()
        guard let scrollView = self.scrollView,let mj_footer = scrollView.mj_footer else { return }
        if let footer = mj_footer as? MJRefreshAutoStateFooter {
            footer.stateLabel?.textColor = UIColor(hex: "666666")
            footer.stateLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        if more {
            mj_footer.state = .idle
            mj_footer.isHidden = false
        }else{
            DispatchQueue.main.asyncAfter(deadline:.now() + 0.01) {
                let height : CGFloat = (scrollView.contentSize.height)
                let sizeHeight : CGFloat = (scrollView.frame.size.height)
                let res : Bool = (self.currentPage == 1) || (height < sizeHeight)
                mj_footer.state = .noMoreData
                mj_footer.isHidden = res
            }
        }
    }
    //MARK:加载失败
    public func endRefreshFailure(){
        if self.currentPage > 1 {
            self.currentPage = self.currentPage - 1
        }
        self.baseEndRefreshing()
        guard let scrollView = self.scrollView,let mj_footer = scrollView.mj_footer else { return }
        mj_footer.isRefreshing ? (mj_footer.state = .idle) : (mj_footer.isHidden = true)
    }
    private func baseEndRefreshing(){
        self.refreshing = false
        guard let scrollView = self.scrollView,let mj_header = scrollView.mj_header else { return }
        mj_header.isRefreshing ? mj_header.endRefreshing() : nil
    }
    //MARK: load first page
    @objc private func headerRefreshing(){
        if self.refreshing == false {
            self.refreshing = true
            self.currentPage = 1
            self.refreshData(page: self.currentPage)
        }
    }
    //MARK:load foot
    @objc private func footerRefreshing(){
        if self.refreshing == false {
            self.refreshing = true
            self.currentPage = self.currentPage + 1
            self.refreshData(page: self.currentPage)
        }
    }
    @objc private func reloadEmptyData(){
        guard let scrollView = self.scrollView else { return }
        if scrollView.isEmptyDataSetVisible{
            scrollView.reloadEmptyDataSet()
        }
    }
    deinit {
        debugPrint(self.classForCoder)
    }
}
extension ATRefreshData :EmptyDataSetSource{
    //MARK:title
    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return self.dataSource?.refreshTitle
    }
    //MARK:subTitle
    public func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return self.dataSource?.refreshSubtitle
    }
    //MARK:logo
    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return self.dataSource?.refreshLogo
    }
    //MARK:logo location bottom + top -
    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return self.dataSource?.refreshVertica ?? (-(at_iphone.statusBar + 44)/2)
    }
    //MARK: logo and title space
    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return self.dataSource?.refreshSpace ?? 15
    }
    public func backgroundColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return self.dataSource?.refreshColor ?? UIColor.white
    }
    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        return self.dataSource?.refreshAnimation
    }
    public func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
        if self.refreshing {
            return nil
        }
        guard let button  = self.dataSource?.refreshButton else { return nil }
        return button.attributedTitle(for: state)
    }
    public func buttonBackgroundImage(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> UIImage? {
        if self.refreshing {
            return nil
        }
        guard let button  = self.dataSource?.refreshButton else { return nil }
        return button.backgroundImage(for: state)
    }
}
extension ATRefreshData :EmptyDataSetDelegate{
    //MARK:DZNEmptyDataSetDelegate
    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        return self.refreshing
    }
    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return true
    }
    public func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView) -> Bool {
        return !self.refreshing
    }
    public func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return !self.refreshing
    }
    public func emptyDataSet(_ scrollView: UIScrollView, didTapView view: UIView) {
        guard let _ = self.dataSource?.refreshButton else {
            self.refreshing ? nil : self.headerRefreshing()
            return
        }
    }
    public func emptyDataSet(_ scrollView: UIScrollView, didTapButton button: UIButton) {
        guard let _ = self.dataSource?.refreshButton else { return }
        self.refreshing ? nil : self.headerRefreshing()
    }
}
