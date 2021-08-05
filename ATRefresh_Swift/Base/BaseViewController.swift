//
//  BaseViewController.swift
//  ATRefresh_Swift
//
//  Created by 王炜圣 on 2021/8/5.
//  Copyright © 2021 wangws1990. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    deinit {
        debugPrint(self.classForCoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.view.backgroundColor = UIColor.white
    }
}
extension BaseViewController : UIGestureRecognizerDelegate{
    //MARK:UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
