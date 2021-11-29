//
//  BaseRefershController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SnapKit
import ATKit_Swift
import Alamofire
class BaseRefershController: BaseViewController {
    //Example
    deinit {
        debugPrint(self.classForCoder)
    }
    lazy var refreshData: ATRefreshData = {
        let refresh = ATRefreshData()
        refresh.delegate = self
        refresh.dataSource = self
        return refresh
    }()
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    public func setupRefresh(scrollView :UIScrollView,options :ATRefreshOption){
        self.refreshData.setupRefresh(scrollView: scrollView, options: options)
    }
    public func endRefresh(more :Bool,empty :String = "数据空空如也...",image :String = "icon_data_empty"){
        self.refreshEmptyToast = empty
        self.refreshEmptyData = image
        self.refreshData.endRefresh(more: more)
    }
    public func endRefreshFailure(error :String = "网络出现异常...",image :String = "icon_net_error"){
        self.refreshEmptyToast = error
        self.refreshEmptyData = image
        self.refreshData.endRefreshFailure()
    }
    private let refreshLoaderToast :String  = "数据加载中..."
    private var refreshEmptyToast  :String  = ""
    private var refreshEmptyData   :String  = ""
    private lazy var images: UIImage = {
        let image  = UIImage(named: "icon_load_data")
        return image ?? UIImage()
    }()
    private lazy var loading: [UIImage] = {
        var images :[UIImage] = [];
        for i in 1...35{
            if let image = UIImage(named:"下拉loading_00\(i)"){
                images.append(image)
            }
        }
        return images
    }()
}

extension BaseRefershController : ATRefreshDataSource{
    var refreshHeaderData: [UIImage] {
        return self.loading
    }
    var refreshFooterData: [UIImage] {
        return self.loading
    }
    var refreshLogo: UIImage{
        if self.refreshData.refreshing {
            return self.images
        }
        return UIImage(named:self.refreshEmptyData) ?? UIImage()
    }
    var refreshAnimation: CAAnimation{
        let animation = CABasicAnimation(keyPath: "transform")
        animation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D: CATransform3DMakeRotation(CGFloat(Double.pi / 2), 0, 0, 1.0))
        animation.duration = 0.3
        animation.isCumulative = true
        animation.repeatCount = MAXFLOAT
        return animation
    }
    var refreshTitle: NSAttributedString{
        let color = self.refreshData.refreshing ? UIColor(hex: "3991f0") : UIColor(hex: "a6a6a6")
        let subTitle = self.refreshData.refreshing ? self.refreshLoaderToast : self.refreshEmptyToast
        return NSAttributedString(string:subTitle, attributes:[.font :UIFont.systemFont(ofSize: 15),.foregroundColor :color])
    }
    var refreshVertica: CGFloat{
        return -(88)/2
    }
}
extension BaseRefershController : ATRefreshDelegate{
    @objc public func refreshData(page:Int){}
}

