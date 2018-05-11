//
//  ViewController.swift
//  PageController
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    private lazy var pageViewManager: PageViewManager = {
        // 创建DNSPageStyle，设置样式
        var style = PageStyle()
        style.isShowBottomLine = true
        style.isTitleScrollEnable = true
        style.titleViewBackgroundColor = UIColor.clear

        // 设置标题内容
        let titles = ["头条", "视频", "娱乐", "要问", "体育" , "科技" , "汽车" , "时尚" , "图片" , "游戏" , "房产"]

        // 创建每一页对应的controller
        let childViewControllers: [PageContentViewController] = titles.map { _  in
            let controller = PageContentViewController()
            controller.view.backgroundColor = UIColor.randomColor
            return controller
        }

        return PageViewManager(style: style, titles: titles, childViewControllers: childViewControllers)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

//        let rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: 40)
//        let titles = ["头条", "视频", "娱乐", "要问", "体育" , "科技" , "汽车" , "时尚" , "图片" , "游戏" , "房产"]
//        let pageTitleView = PageTitleView(frame: rect, style: PageStyle(), titles: titles)
//        view.addSubview(pageTitleView)
//
//
//        let childControllers: [PageContentViewController] = titles.map{ _ in
//            let vc = PageContentViewController()
//            vc.view.backgroundColor = UIColor.randomColor
//            return vc
//        }
//
//        let size = UIScreen.main.bounds.size
//        let cRect = CGRect(x: 0, y: 60, width: size.width, height: size.height - 60)
//        let content = PageContentView(frame: cRect, style: PageStyle(), childViewController: childControllers)
//        view.addSubview(content)
//
//        pageTitleView.delegate = content
//        content.delegate = pageTitleView


        let title = pageViewManager.titleView
        title.frame = CGRect(x: 0, y: 20, width: view.bounds.width, height: 40)
        let content = pageViewManager.contentView
        content.frame = CGRect(x: 0, y: 60, width: view.bounds.width, height: view.bounds.height - 60)
        view.addSubview(title)
        view.addSubview(content)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

