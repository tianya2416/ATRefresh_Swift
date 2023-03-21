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
    var TAGS  :String? = ""
    var imgsrc:String?  = ""
    var title :String? = ""
    
    var topicid    :String?  = ""
    var shortIntro :String? = ""
    required init() {}
    
    func mapping(mapper: HelpingMapper) {
        mapper <<<
            self.topicid <-- ["topicid","_id"]
        mapper <<<
            self.shortIntro <-- ["shortIntro","description"]
    }
}
