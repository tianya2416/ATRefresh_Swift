//
//  ATGroupConnectionController.swift
//  ATRefresh_Swift
//
//  Created by wangws1990 on 2020/5/11.
//  Copyright © 2020 wangws1990. All rights reserved.
//

import UIKit

class ATGroupConnectionController: BaseConnectionController {

    lazy var listData : [ATGroupModel] = {
        return []
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.showNavTitle(title: "玄幻")
        self.setupEmpty(scrollView: self.collectionView);
        self.setupRefresh(scrollView: self.collectionView, options: .defaults);
    }
    override func refreshData(page: Int) {
        let size : Int = 20;
        ApiMoya.apiMoyaRequest(target: .apiClassify(page: page, size: size, group: "male", name: "玄幻"), sucesss: { (json) in
            if page == 1{
                self.listData.removeAll();
            }
            var arrayDatas :[ATGroupModel] = [];
            if let data = [ATGroupModel].deserialize(from: json.rawString()){
                arrayDatas = data as! [ATGroupModel]
            }
            self.listData.append(contentsOf: arrayDatas);
            self.collectionView.reloadData();
            self.endRefresh(more: arrayDatas.count > 0)
        }) { (error) in
            self.endRefreshFailure();
        }
    }
    //MARK:UICollectionViewDelegateFlowLayout
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2);
    }
    //MARK:UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listData.count;
    }
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width : CGFloat = (self.view.frame.size.width - 6)/2
        let height : CGFloat = width*1.3 + 50
        return CGSize.init(width:width, height:height);
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : ATGroupCollectionViewCell = ATGroupCollectionViewCell.cellForCollectionView(collectionView: collectionView, indexPath: indexPath);
        cell.model = self.listData[indexPath.row];
        return cell;
    }
    //MARK:UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
