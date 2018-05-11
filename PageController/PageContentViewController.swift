//
//  PageContentViewController.swift
//  PageController
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PageContentViewController: PageReloadable {

    func titleViewDidSelectedSameTitle() {
        print("重复点击了标题")
    }

    func contentViewDidEndScroll() {
        print("contentView滑动结束")
    }
}
