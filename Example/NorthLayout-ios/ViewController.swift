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

        view.backgroundColor = .white

        let iconView = UIImageView(image: colorImage(UIColor(red: 0.63, green: 0.9, blue: 1, alpha: 1)))
        let iconWidth = CGFloat(32)
        iconView.layer.cornerRadius = iconWidth / 2
        iconView.clipsToBounds = true
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        
        let dateLabel = UILabel()
        dateLabel.text = "1 min ago"
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .lightGray
        dateLabel.textAlignment = .right
        
        let textLabel = UILabel()
        textLabel.text = "Some text go here"
        
        let favButton = UIButton(type: .system)
        favButton.setTitle("⭐️", for: [])
        favButton.backgroundColor = UIColor(red: 0.17, green: 0.29, blue: 0.45, alpha: 1.0)
        favButton.setTitleColor(.white, for: [])
        favButton.layer.cornerRadius = 4
        favButton.clipsToBounds = true
        
        let replyButton = UIButton(type: .system)
        replyButton.setTitle("Reply", for: [])
        replyButton.backgroundColor = favButton.backgroundColor
        replyButton.setTitleColor(.white, for: [])
        replyButton.layer.cornerRadius = 4
        replyButton.clipsToBounds = true

        let headerView = HeaderView()

        // example for View Controller level autolayout with respecting safe area layout guides
        let autolayout = northLayoutFormat(["p": 8, "iconWidth": iconWidth], [
            "header": headerView,
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
        autolayout("V:[header]-p-[icon(==iconWidth)]-p-[text]")
        autolayout("V:[header]-p-[name(==icon)]")
        autolayout("V:[header]-p-[date]")
        autolayout("V:[text]-p-[fav]")
        autolayout("V:[text]-p-[reply]")

        let nonSafeAreaAutolayout = northLayoutFormat([:], ["header": headerView], useSafeArea: false)
        nonSafeAreaAutolayout("H:|[header]|")
        nonSafeAreaAutolayout("V:|[header(>=64)]")

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// Example for view level autolayout with respecting safe area layout guides
final class HeaderView: UIView {
    let leftColumn: UIView = {
        let v = MinView() // non -1 intrinsic size for compact layout
        v.backgroundColor = .darkGray
        return v
    }()
    let rightColumn: UIView = {
        let v = MinView() // non -1 intrinsic size for compact layout
        v.backgroundColor = .lightGray
        return v
    }()

    let iconView: UIView = {
        let v = UIView(frame: .zero)
        v.backgroundColor = UIColor(red: 0.63, green: 0.9, blue: 1, alpha: 1)
        v.clipsToBounds = true
        v.layer.cornerRadius = 32
        return v
    }()
    let nameLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.text = "@screenname" // @"s" // for short
        l.textColor = .white
        l.textAlignment = .center
        return l
    }()
    let bioLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.text = "some text"
        l.textColor = .black
        l.backgroundColor = .white
        l.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
        return l
    }()

    init() {
        super.init(frame: .zero)

        let autolayout = northLayoutFormat([:], ["left": leftColumn, "right": rightColumn])
        autolayout("H:|[left][right]|")
        autolayout("V:|[left]|")
        autolayout("V:|[right]|")
        rightColumn.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)

        let leftLayout = leftColumn.northLayoutFormat(["p": 8], [
            "icon": iconView,
            "name": nameLabel])
        leftLayout("H:[icon(==64)]")
        leftLayout("V:|-p-[icon(==64)]-p-[name]-p-|")
        leftColumn.layoutMarginsGuide.leftAnchor.constraint(lessThanOrEqualTo: iconView.leftAnchor).isActive = true
        leftColumn.layoutMarginsGuide.rightAnchor.constraint(greaterThanOrEqualTo: iconView.rightAnchor).isActive = true
        leftColumn.layoutMarginsGuide.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true

        leftColumn.layoutMarginsGuide.leftAnchor.constraint(lessThanOrEqualTo: nameLabel.leftAnchor).isActive = true
        leftColumn.layoutMarginsGuide.rightAnchor.constraint(greaterThanOrEqualTo: nameLabel.rightAnchor).isActive = true
        leftColumn.layoutMarginsGuide.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true

        let rightLayout = rightColumn.northLayoutFormat(["p": 8], [
            "bio": bioLabel])
        rightLayout("V:|-p-[bio]-(>=p)-|")
        rightColumn.layoutMarginsGuide.leftAnchor.constraint(equalTo: bioLabel.leftAnchor).isActive = true
        rightColumn.layoutMarginsGuide.rightAnchor.constraint(equalTo: bioLabel.rightAnchor).isActive = true

        setContentHuggingPriority(.required, for: .vertical)
    }
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
}

