//
//  ViewController.swift
//  NorthLayout
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//

import UIKit
import NorthLayout


private func colorImage(color: UIColor) -> UIImage {
    UIGraphicsBeginImageContext(CGSizeMake(1, 1))
    color.set()
    UIRectFill(CGRectMake(0, 0, 1, 1))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
}


class ViewController: UIViewController {
    override func loadView() {
        super.loadView()
        
        edgesForExtendedLayout = nil
        view.backgroundColor = UIColor.whiteColor()
        
        let iconView = UIImageView(image: colorImage(UIColor(red: 0.63, green: 0.9, blue: 1, alpha: 1)))
        let iconWidth = CGFloat(32)
        iconView.layer.cornerRadius = iconWidth / 2
        iconView.clipsToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        
        let dateLabel = UILabel()
        dateLabel.text = "1 min ago"
        dateLabel.font = UIFont.systemFontOfSize(12)
        dateLabel.textColor = UIColor.lightGrayColor()
        
        let textLabel = UILabel()
        textLabel.text = "Some text go here"
        
        let autolayout = view.northLayoutFormat(["p": 8, "iconWidth": iconWidth], [
            "icon": iconView,
            "name": nameLabel,
            "date": dateLabel,
            "text": textLabel,
            ])
        autolayout("H:|-p-[icon(==iconWidth)]-p-[name]-p-[date]-p-|")
        autolayout("H:|-p-[text]-p-|")
        autolayout("V:|-p-[icon(==iconWidth)]-p-[text]")
        autolayout("V:|-p-[name(==icon)]")
        autolayout("V:|-p-[date]")
    }
}

