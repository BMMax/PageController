//
//  PageView.swift
//  PageController
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit
class PageView: UIView {

    private (set) public var style: PageStyle
    private (set) public var titles: [String]
    private (set) public var childViewControllers: [UIViewController]

    private (set) lazy var titleView = PageTitleView(frame: .zero, style: style, titles: titles)
    private (set) lazy var contentView = PageContentView(frame: .zero, style: style, childViewController: childViewControllers)

    public init(frame: CGRect,
                   style: PageStyle,
                   titles: [String],
                   childViewControllers: [UIViewController]) {

        self.style = style
        self.titles = titles
        self.childViewControllers = childViewControllers
        super.init(frame: frame)
        setupUI()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PageView {
    private func setupUI() {
        let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleViewHeight)
        titleView.frame = titleFrame
        addSubview(titleView)

        let contentFrame = CGRect(x: 0, y: style.titleViewHeight, width: bounds.width, height: bounds.height - style.titleViewHeight)
        contentView.frame = contentFrame
        contentView.backgroundColor = UIColor.white
        addSubview(contentView)

        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
