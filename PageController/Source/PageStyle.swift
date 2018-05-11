//
//  PageStyle.swift
//  PageController
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit

public struct PageStyle {

    public let animateDuration: TimeInterval = 0.25
    /// 标题是否可以滚动
    public var isTitleScrollEnable: Bool = true


    /// titleView的一些属性
    public var titleViewHeight: CGFloat = 44
    public var titleColor: UIColor = UIColor.black
    public var titleSelectedColor: UIColor = UIColor.blue
    public var titleFontSize: CGFloat = 15
    public var titleViewBackgroundColor: UIColor = UIColor.white
    public var titleMargin: CGFloat = 30

    /// 是否显示滚动条
    public var isShowBottomLine: Bool = false
    public var bottomLineColor: UIColor = UIColor.blue
    public var bottomLineHeight: CGFloat = 2

    /// 是否需要缩放功能
    public var isScaleEnable: Bool = true
    public var maximumScaleFactor: CGFloat = 1.2

    /// 是否需要显示coverView
    public var isShowCoverView: Bool = false
    public var coverViewBackgroundColor: UIColor = UIColor.black
    public var coverViewAlpha: CGFloat = 0.4
    public var coverMargin: CGFloat = 8
    public var coverViewHeight: CGFloat = 25
    public var coverViewRadius: CGFloat = 12



    /// contentView是否可以滚动
    public var isContentScrollEnable : Bool = true
    public var contentViewBackgroundColor = UIColor.white

}
