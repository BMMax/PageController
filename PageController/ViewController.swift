//
//  ViewController.swift
//  PageController
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = CGRect(x: 0, y: 64, width: view.bounds.width, height: 40)
        let titles = ["头条", "视频", "娱乐", "要问", "体育" , "科技" , "汽车" , "时尚" , "图片" , "游戏" , "房产"]
        let pageTitleView = PageTitleView(frame: rect, style: PageStyle(), titles: titles)
        view.addSubview(pageTitleView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

