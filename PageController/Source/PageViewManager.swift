//
//  PageViewManager.swift
//  PageController
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit


class PageViewManager: NSObject {

    private (set) public var style: PageStyle
    private (set) public var titles: [String]
    private (set) public var childViewControllers: [UIViewController]

    private (set) public lazy var titleView = PageTitleView(frame: .zero, style: style, titles: titles)
    private (set) public lazy var contentView = PageContentView(frame: .zero, style: style, childViewController: childViewControllers)

    public init(style: PageStyle, titles: [String], childViewControllers: [UIViewController]) {

        self.style = style
        self.titles = titles
        self.childViewControllers = childViewControllers
        super.init()

        setupUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageViewManager {
    private func setupUI() {

        titleView.backgroundColor = UIColor.clear

        contentView.backgroundColor = UIColor.white

        titleView.delegate = contentView
        contentView.delegate = titleView
    }
}
