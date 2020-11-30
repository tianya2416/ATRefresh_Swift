//
//  ATGroupCollectionViewCell.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class ATGroupCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLba: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    var model : ATGroupModel = ATGroupModel(){
        didSet{
            let item = model ;
            self.imageV.setGkImageWithURL(url: item.cover ?? "");
            self.titleLba.text = item.title;
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
