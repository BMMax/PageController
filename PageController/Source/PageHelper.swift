//
//  PageHelper.swift
//  PageController
//
//  Created by user on 2018/5/11.
//  Copyright © 2018年 mobin. All rights reserved.
//

import UIKit
typealias ColorRGB = (red: CGFloat, green: CGFloat, blue: CGFloat)




extension UIColor {


    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1.0) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
    }



    convenience init?(hex: String, alpha: CGFloat = 1.0) {

        guard hex.count >= 6 else {
            return nil
        }

        var hexString = hex.uppercased()

        if (hexString.hasPrefix("##") || hexString.hasPrefix("0x")) {

            hexString = (hexString as NSString).substring(from: 2)
        }

        if (hexString.hasPrefix("#")) {

            hexString = (hexString as NSString).substring(from: 1)
        }


        var range = NSRange(location: 0, length: 2)
        let rStr = (hexString as NSString).substring(with: range)
        range.location = 2
        let gStr = (hexString as NSString).substring(with: range)
        range.location = 4
        let bStr = (hexString as NSString).substring(with: range)


        var r: UInt32 = 0
        var g: UInt32 = 0
        var b: UInt32 = 0
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)

        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)
    }

    func getRGB() -> (CGFloat, CGFloat, CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        return (red * 255, green * 255, blue * 255)
    }
}
