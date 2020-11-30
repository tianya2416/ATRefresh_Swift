//
//  ATGroupModel.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import HandyJSON

class ATGroupModel: HandyJSON {
    var bookId    :String?       = "";
    var updateTime:TimeInterval  = 0;
    var author:String? = "";
    var cover:String?  = "";
    var shortIntro :String? = ""
    var title:String? = "";
    var majorCate:String? = "";
    var minorCate:String? = "";
    var lastChapter:String? = "";
    
    var retentionRatio :Float! = 0.0;
    var latelyFollower :Int? = 0;
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.bookId <-- ["bookId","_id"]
        mapper <<<
            self.shortIntro <-- ["shortIntro","longIntro"]
    }
}
