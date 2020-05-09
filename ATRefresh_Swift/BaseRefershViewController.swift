//
//  BaseRefershViewController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import SnapKit
class BaseRefershViewController: ATRefreshController {
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self;
    }
}
extension BaseRefershViewController : ATRefreshDataSource{
    func refreshFooterData() -> [UIImage] {
        return self.images;
    }
    
    func refreshHeaderData() -> [UIImage] {
        return self.images;
    }
    
    func refreshLoaderData() -> UIImage {
        return UIImage.animatedImage(with:self.images, duration: 0.35) ?? UIImage.init();
    }
    
    func refreshEmptyData() -> UIImage {
        return UIImage.init(named: "icon_data_empty") ?? UIImage.init();
    }
    
    func refreshNoNetData() -> UIImage {
        return UIImage.init(named: "icon_net_error") ?? UIImage.init();
    }
    func refreshEmptyDataToast() -> String {
        return "Data is empty...";
    }
    func refreshNoNetDataToast() -> String {
        return "Net is error...";
    }
    func refreshLoadingDataToast() -> String {
        return "Datas is loading...";
    }
    
    
}
