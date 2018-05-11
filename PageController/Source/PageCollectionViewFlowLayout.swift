//
//  PageCollectionViewFlowLayout.swift
//  PageController
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit

class PageCollectionViewFlowLayout: UICollectionViewFlowLayout {


    ///  通过设置offset的值，达到初始化的pageView默认显示某一页的效果，默认显示第一页
    var offset: CGFloat?

    override func prepare() {
        super.prepare()

        guard let offset = offset else {return}
        collectionView?.contentOffset = CGPoint(x: offset, y: 0)
    }
}
