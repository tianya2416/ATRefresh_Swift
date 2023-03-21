//
//  GKLoad.swift
//  MySwiftObject
//
//  Created by wangws1990 on 2019/9/25.
//  Copyright © 2019 wangws1990. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView{
    public func setGkImageWithURL(url:String){
        
        self.setGkImageWithURL(url: url, placeholder: UIImage.imageWithColor(color: UIColor.init(hex: "f8f8f8")));
    }
    public func setGkImageWithURL(url:String,placeholder:UIImage){
        self.setGkImageWithURL(url: url, placeholder: placeholder, unencode: true);
    }
    public func setGkImageWithURL(url:String,placeholder:UIImage,unencode:Bool){
//        var str : String!;
//        if url.hasPrefix("/agent/"){
//            str = url.replacingOccurrences(of: "/agent/", with: "");
//        }
//        str = unencode ? str.removingPercentEncoding : str;
        //kf 多图会有性能问题
        self.kf.setImage(with: URL(string: url), placeholder: placeholder)
    }
    
}

