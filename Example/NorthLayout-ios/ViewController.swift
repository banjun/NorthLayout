//
//  ViewController.swift
//  NorthLayout
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//

import UIKit
import NorthLayout


private func colorImage(_ color: UIColor) -> UIImage {
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    color.set()
    UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
}


class ViewController: UIViewController {
    override func loadView() {
        super.loadView()

        view.backgroundColor = .whiteColor()

        let iconView = UIImageView(image: colorImage(UIColor(red: 0.63, green: 0.9, blue: 1, alpha: 1)))
        let iconWidth = CGFloat(32)
        iconView.layer.cornerRadius = iconWidth / 2
        iconView.clipsToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        
        let dateLabel = UILabel()
        dateLabel.text = "1 min ago"
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .lightGray()
        
        let textLabel = UILabel()
        textLabel.text = "Some text go here"
        
        let favButton = UIButton(type: .system)
        favButton.setTitle("⭐️", for: [])
        favButton.backgroundColor = UIColor(red: 0.17, green: 0.29, blue: 0.45, alpha: 1.0)
        favButton.setTitleColor(.white(), for: [])
        favButton.layer.cornerRadius = 4
        favButton.clipsToBounds = true
        
        let replyButton = UIButton(type: .system)
        replyButton.setTitle("Reply", for: [])
        replyButton.backgroundColor = favButton.backgroundColor
        replyButton.setTitleColor(.white(), for: [])
        replyButton.layer.cornerRadius = 4
        replyButton.clipsToBounds = true
        
        let autolayout = northLayoutFormat(["p": 8, "iconWidth": iconWidth], [
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

