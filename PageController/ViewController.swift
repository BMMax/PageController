//
//  ViewController.swift
//  PageController
//
//  Created by user on 2018/5/10.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit

extension UIColor {
    static var randomColor: UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(256))/255.0, green: CGFloat(arc4random_uniform(256))/255.0, blue: CGFloat(arc4random_uniform(256))/255.0, alpha: 1.0)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let rect = CGRect(x: 0, y: 20, width: view.bounds.width, height: 40)
        let titles = ["头条", "视频", "娱乐", "要问", "体育" , "科技" , "汽车" , "时尚" , "图片" , "游戏" , "房产"]
        let pageTitleView = PageTitleView(frame: rect, style: PageStyle(), titles: titles)
        view.addSubview(pageTitleView)


        let childControllers: [PageContentViewController] = titles.map{ _ in
            let vc = PageContentViewController()
            vc.view.backgroundColor = UIColor.randomColor
            return vc
        }

        let size = UIScreen.main.bounds.size
        let cRect = CGRect(x: 0, y: 60, width: size.width, height: size.height - 60)
        let content = PageContentView(frame: cRect, style: PageStyle(), childViewController: childControllers)
        view.addSubview(content)

        pageTitleView.delegate = content
        content.delegate = pageTitleView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

