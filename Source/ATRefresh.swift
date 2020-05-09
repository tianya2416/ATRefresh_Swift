//
//  ATRefresh.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import Foundation
import UIKit

public let RefreshPageStart : Int = (1)
public let RefreshPageSize  : Int = (20)

public let iPhone_X        : Bool      = ATRefresh.iPhone_X();
public let STATUS_BAR_HIGHT:CGFloat    = (iPhone_X ? 44: 20)//状态栏
public let NAVI_BAR_HIGHT  :CGFloat    = (iPhone_X ? 88: 64)//导航栏
public let TAB_BAR_ADDING  :CGFloat    = (iPhone_X ? 34 : 0)//iphoneX斜刘海

struct ATRefreshOption :OptionSet {
    public var rawValue: Int
    static var none          : ATRefreshOption{return ATRefreshOption(rawValue: 0)}
    static var header        : ATRefreshOption{return ATRefreshOption(rawValue: 1<<0)};
    static var footer        : ATRefreshOption{return ATRefreshOption(rawValue: 1<<1)};
    static var autoHeader    : ATRefreshOption{return ATRefreshOption(rawValue: 1<<2)};
    static var autoFooter    : ATRefreshOption{return ATRefreshOption(rawValue: 1<<3)};
    static var defaultHidden : ATRefreshOption{return ATRefreshOption(rawValue: 1<<4)};
    static var defaults      : ATRefreshOption{return ATRefreshOption(rawValue: header.rawValue|autoHeader.rawValue|footer.rawValue|autoFooter.rawValue)};
}
@objc protocol ATRefreshDataSource : NSObjectProtocol {
    @objc func refreshFooterData() ->[UIImage];
    @objc func refreshHeaderData() ->[UIImage];
    @objc func refreshLoaderData() ->UIImage;
    @objc func refreshEmptyData()  ->UIImage;
    @objc func refreshNoNetData()  ->UIImage;
    
    @objc optional func refreshLoadingDataToast()   ->String;
    @objc optional func refreshNoNetDataToast()     ->String;
    @objc optional func refreshEmptyDataToast()     ->String;
}
public class ATRefresh : NSObject{
    class func iPhone_X() -> Bool{
        let window : UIWindow = ((UIApplication.shared.delegate?.window)!)!;
           if #available(iOS 11.0, *) {
               let inset : UIEdgeInsets = window.safeAreaInsets
               if inset.bottom == 34 || inset.bottom == 21 {
                   return true;
               }else{
                   return false
               }
           } else {
              return false;
           };
    }
}
