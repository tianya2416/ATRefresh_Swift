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

public var refreshEmptyData : UIImage = UIImage(named: "icon_data_empty") ?? UIImage()
public let refreshErrorData : UIImage = UIImage(named: "icon_net_error") ?? UIImage()

private let refreshLoaderToast: String = "Data loading..."
private var refreshErrorToast : String = "Net Error..."
private var refreshEmptyToast : String = "Data Empty..."

class BaseRefershController: UIViewController {
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
    var refreshNetAvailable : Bool{
        get{
            return NetworkReachabilityManager()!.isReachable
        }
    }
    private lazy var images: [UIImage] = {
        var images :[UIImage] = []
        for i in 0...35{
            let image = UIImage.init(named:String("下拉loading_00") + String(i < 10 ? ("0"+String(i)) : String(i)));
            if image != nil {
                images.append(image!)
            }
        }
        return images
    }()
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = UIColor.white
    }
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
    public func endRefreshFailure(error :String = refreshErrorToast){
        refreshErrorToast = error
        self.refreshData.endRefreshFailure()
    }
}
extension BaseRefershController : ATRefreshDataSource{
    var refreshHeaderData: [UIImage] {
        return self.images
    }
    var refreshFooterData: [UIImage] {
        return self.images
    }
    var refreshLogo: UIImage{
        let image : UIImage = (self.refreshData.refreshing ? UIImage.animatedImage(with: self.images, duration: 0.35)! : (self.refreshNetAvailable ? refreshEmptyData : refreshErrorData))
        return image
    }
    var refreshTitle: NSAttributedString{
        let text :String = self.refreshData.refreshing ? refreshLoaderToast : (!self.refreshNetAvailable ? refreshErrorToast : refreshEmptyToast)
        var dic : [NSAttributedString.Key : Any ] = [:]
        let font : UIFont = UIFont.systemFont(ofSize: 16)
        let color : UIColor = UIColor(hex: "666666")
        dic.updateValue(font, forKey: .font)
        dic.updateValue(color, forKey: .foregroundColor)
        let att : NSAttributedString = NSAttributedString(string:text, attributes:(dic))
        return att
    }
}
extension BaseRefershController : ATRefreshDelegate{
    @objc public func refreshData(page:Int){}
}
extension BaseRefershController : UIGestureRecognizerDelegate{
    //MARK:UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
