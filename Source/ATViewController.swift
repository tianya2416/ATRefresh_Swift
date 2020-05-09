//
//  ATViewController.swift
//  GKGame_Swift
//
//  Created by wangws1990 on 2019/9/29.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit

public class ATViewController: UIViewController,UIGestureRecognizerDelegate {
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = [];
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self;
        self.view.backgroundColor = UIColor.white;
    }
    //MARK:UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true;
    }
}
