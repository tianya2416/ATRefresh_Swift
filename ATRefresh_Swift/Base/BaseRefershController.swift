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

class BaseRefershController: ATRefreshController,UIGestureRecognizerDelegate {
    //Example
    private lazy var images: [UIImage] = {
        var images :[UIImage] = [];
        for i in 0...35{
            let image = UIImage.init(named:String("下拉loading_00") + String(i < 10 ? ("0"+String(i)) : String(i)));
            if image != nil {
                images.append(image!);
            }
        }
        return images;
    }()
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [];
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.view.backgroundColor = UIColor.white;
        self.dataSource = self;
    }
    //MARK:UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
    
}
extension BaseRefershController : ATRefreshDataSource{
    var refreshLoaderData: [UIImage] {
        return self.images;
    }
    var refreshFooterData: [UIImage] {
        return self.images;
    }
    var refreshHeaderData: [UIImage] {
        return self.images;
    }
    
    var refreshEmptyData: UIImage {
        return UIImage.init(named: "icon_data_empty") ?? UIImage.init();
    }
    
    var refreshErrorData: UIImage {
        return UIImage.init(named: "icon_data_empty") ?? UIImage.init();
    }
    func refreshEmptyToast() -> String {
        return "数据空空如也"
    }
    func refreshLoaderToast() -> String {
        return "数据加载中"
    }
    func refreshErrorToast() -> String {
        return "网络出现问题了"
    }
}