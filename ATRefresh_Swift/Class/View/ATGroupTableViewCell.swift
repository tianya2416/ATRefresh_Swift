//
//  ATGroupTableViewCell.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/9.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit
class ATGroupTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLab: UILabel!
    
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var subTitleLab: UILabel!
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var imageV: UIImageView!
    var model : ATGroupModel?{
        didSet{
            guard let item = model else { return }
            self.imageV.setGkImageWithURL(url: item.imgsrc ?? "");
            self.titleLab.text = item.title;
            self.subTitleLab.text = item.shortIntro;
            self.nickNameLab.text = item.TAGS;
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.favBtn.layer.masksToBounds = true
        self.favBtn.layer.cornerRadius = 5;
        self.favBtn.layer.borderWidth = 1
        self.favBtn.layer.borderColor = UIColor.blue.cgColor
        // Initialization code
    }

    @IBAction func favAction(_ sender: UIButton) {
        ApiDataQueue.insertData(primaryId: self.model?.topicid ?? "", content: self.model?.toJSONString() ?? "") { (finish) in
            if (finish){
                print("收藏成功");
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
