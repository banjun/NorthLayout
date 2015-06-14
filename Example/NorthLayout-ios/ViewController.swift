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
        
        edgesForExtendedLayout = .None
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
        
        let favButton = UIButton(type: .System)
        favButton.setTitle("⭐️", forState: .Normal)
        favButton.backgroundColor = UIColor(red: 0.17, green: 0.29, blue: 0.45, alpha: 1.0)
        favButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        favButton.layer.cornerRadius = 4
        favButton.clipsToBounds = true
        
        let replyButton = UIButton(type: .System)
        replyButton.setTitle("Reply", forState: .Normal)
        replyButton.backgroundColor = favButton.backgroundColor
        replyButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        replyButton.layer.cornerRadius = 4
        replyButton.clipsToBounds = true
        
        let autolayout = view.northLayoutFormat(["p": 8, "iconWidth": iconWidth], [
            "icon": iconView,
            "name": nameLabel,
            "date": dateLabel,
            "text": textLabel,
            "fav": favButton,
            "reply": replyButton,
            ])
        autolayout("H:|-p-[icon(==iconWidth)]-p-[name]-p-[date]-p-|")
        autolayout("H:|-p-[text]-p-|")
        autolayout("H:|-p-[fav]-p-[reply(==fav)]-p-|")
        autolayout("V:|-p-[icon(==iconWidth)]-p-[text]")
        autolayout("V:|-p-[name(==icon)]")
        autolayout("V:|-p-[date]")
        autolayout("V:[text]-p-[fav]")
        autolayout("V:[text]-p-[reply]")
    }
}

