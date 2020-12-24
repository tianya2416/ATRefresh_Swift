//
//  ATRefresh.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import Foundation
import UIKit

public struct ATRefreshOption :OptionSet {
    public let rawValue : Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    public static var none          : ATRefreshOption{return ATRefreshOption(rawValue: 0)}
    public static var header        : ATRefreshOption{return ATRefreshOption(rawValue: 1<<0)}
    public static var footer        : ATRefreshOption{return ATRefreshOption(rawValue: 1<<1)}
    public static var autoHeader    : ATRefreshOption{return ATRefreshOption(rawValue: 1<<2)}
    public static var autoFooter    : ATRefreshOption{return ATRefreshOption(rawValue: 1<<3)}
    public static var defaults      : ATRefreshOption{return ATRefreshOption(rawValue: header.rawValue|autoHeader.rawValue|footer.rawValue|autoFooter.rawValue)}
}

@objc public protocol ATRefreshDataSource : NSObjectProtocol {
    
    @objc optional var refreshHeaderData  :[UIImage] {get}
    @objc optional var refreshFooterData  :[UIImage] {get}
    
    @objc optional var refreshLogo        : UIImage{get}
    @objc optional var refreshTitle       : NSAttributedString {get}
    @objc optional var refreshSubtitle    : NSAttributedString {get}

    @objc optional var refreshVertica     : CGFloat {get}
    @objc optional var refreshSpace       : CGFloat {get}
    @objc optional var refreshColor       : UIColor {get}
    @objc optional var refreshButton      : UIButton{get}
    @objc optional var refreshAnimation   : CAAnimation{get}
}
public protocol ATRefreshDelegate : NSObjectProtocol {
    func refreshData(page :Int)
}

public let at_iphone                 = ATRefresh.iPhone_Bar()
public let at_statusBar              = at_iphone.statusBar//状态栏高度
public let at_naviBar                = at_statusBar + 44  //导航栏高度
public let at_tabBar                 = at_iphone.tabBar   //底部tabbar高度
public let at_iphoneX                = at_iphone.iphoneX  //是否是有刘海

public class ATRefresh : NSObject{
    class func iPhone_Bar() ->(iphoneX :Bool,statusBar : CGFloat,tabBar : CGFloat){
        if let window = UIApplication.shared.delegate?.window {
            if #available(iOS 11.0, *) {
                let inset : UIEdgeInsets = window!.safeAreaInsets
                return (inset.bottom > 0, inset.top,inset.bottom)
            } else {
                 return (false,20,0)
            }
        }
        return (false,20,0)
    }
    
}

public extension UIImage{
    class func imageWithColor(color:UIColor) -> UIImage{
        
         let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
         UIGraphicsBeginImageContext(rect.size)
         let context = UIGraphicsGetCurrentContext()
         context!.setFillColor(color.cgColor)
         context!.fill(rect)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return image!
     }
}

public extension UIColor {
    convenience init(hex string: String) {
      var hex = string.hasPrefix("#")
        ? String(string.dropFirst())
        : string
      guard hex.count == 3 || hex.count == 6
        else {
          self.init(white: 1.0, alpha: 0.0)
          return
      }
      if hex.count == 3 {
        for (index, char) in hex.enumerated() {
          hex.insert(char, at: hex.index(hex.startIndex, offsetBy: index * 2))
        }
      }
      guard let intCode = Int(hex, radix: 16) else {
        self.init(white: 1.0, alpha: 0.0)
        return
      }
      self.init(
        red:   CGFloat((intCode >> 16) & 0xFF) / 255.0,
        green: CGFloat((intCode >> 8) & 0xFF) / 255.0,
        blue:  CGFloat((intCode) & 0xFF) / 255.0, alpha: 1.0)
    }
    func alpha(_ value: CGFloat) -> UIColor {
      return withAlphaComponent(value)
    }
}
