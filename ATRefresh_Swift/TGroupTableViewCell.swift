//
//  TGroupTableViewCell.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
import Kingfisher
class TGroupTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    var model : ATGroupModel = ATGroupModel(){
        didSet{
            let item = model ;
            self.imageV.kf.setImage(with: URL.init(string: item.cover!))
            self.titleLab.text = item.title;
            self.subTitleLab.text = item.shortIntro;
            self.nickNameLab.text = item.author;
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
