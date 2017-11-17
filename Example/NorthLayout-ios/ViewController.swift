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

private let iconWidth: CGFloat = 32

class ViewController: UIViewController {
    let headerView = HeaderView()

    let iconView: UIImageView = {
        let v = UIImageView(image: colorImage(UIColor(red: 0.63, green: 0.9, blue: 1, alpha: 1)))
        v.layer.cornerRadius = iconWidth / 2
        v.clipsToBounds = true
        return v
    }()

    let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Name"
        return l
    }()

    let dateLabel: UILabel = {
        let l = UILabel()
        l.text = "1 min ago"
        l.font = UIFont.systemFont(ofSize: 12)
        l.textColor = .lightGray
        l.textAlignment = .right
        return l
    }()


    let textLabel: UILabel = {
        let l = UILabel()
        l.text = "Some text go here"
        return l
    }()

    let favButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("⭐️", for: [])
        b.backgroundColor = UIColor(red: 0.17, green: 0.29, blue: 0.45, alpha: 1.0)
        b.setTitleColor(.white, for: [])
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(fav), for: .touchUpInside)
        return b
    }()

    let replyButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Nav", for: [])
        b.backgroundColor = UIColor(red: 0.17, green: 0.29, blue: 0.45, alpha: 1.0)
        b.setTitleColor(.white, for: [])
        b.layer.cornerRadius = 4
        b.clipsToBounds = true
        b.addTarget(self, action: #selector(nav), for: .touchUpInside)
        return b
    }()

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white

        let autolayout = northLayoutFormat(["p": 8, "iconWidth": iconWidth], [
            "header": headerView,
            "icon": iconView,
            "name": nameLabel,
            "date": dateLabel,
            "text": textLabel,
            "fav": favButton,
            "reply": replyButton,
            ])
        autolayout("H:|[header]|")
        autolayout("V:|[header(<=192)]")
        autolayout("H:||[icon(==iconWidth)]-p-[name]-p-[date]||")
        autolayout("H:||[text]||")
        autolayout("H:||[reply]-p-[fav(==reply)]||")
        autolayout("V:[header]-p-[icon(==iconWidth)]-p-[text]")
        autolayout("V:[header]-p-[name(==icon)]")
        autolayout("V:[header]-p-[date]")
        autolayout("V:[text]-p-[fav]")
        autolayout("V:[text]-p-[reply]")
    }

    @objc func nav() {
        // show/hide navigation bar with animations
        guard let nc = navigationController else { return }
        nc.setNavigationBarHidden(!nc.isNavigationBarHidden, animated: true)
        UIView.animate(withDuration: TimeInterval(UINavigationControllerHideShowBarDuration)) {
            self.view.setNeedsUpdateConstraints() // not all the layout changes cause updating constraints
            self.view.layoutIfNeeded() // re-layout within the animation block
        }
    }

    @objc func fav() {
        headerView.bioLabel.text = (headerView.bioLabel.text ?? "") + "\n⭐️"
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
        l.numberOfLines = 0
        return l
    }()

    init() {
        super.init(frame: .zero)

        let autolayout = northLayoutFormat([:], ["left": leftColumn, "right": rightColumn])
        autolayout("H:|[left][right]|")
        autolayout("V:|[left]|")
        autolayout("V:|[right]|")
        rightColumn.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)

        let leftLayout = leftColumn.northLayoutFormat([:], [
            "icon": iconView,
            "name": nameLabel])
        leftLayout("H:||-(>=0)-[icon(==64)]-(>=0)-||")
        leftLayout("H:||-(>=0)-[name]-(>=0)-||")
        leftLayout("V:||[icon(==64)]-[name]-(>=0)-||")
        leftColumn.layoutMarginsGuide.centerXAnchor.constraint(equalTo: iconView.centerXAnchor).isActive = true
        leftColumn.layoutMarginsGuide.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor).isActive = true

        let rightLayout = rightColumn.northLayoutFormat([:], [
            "bio": bioLabel])
        rightLayout("H:||[bio]||")
        rightLayout("V:||[bio]-(>=0)-||")

        setContentHuggingPriority(.required, for: .vertical)
    }
    required init?(coder aDecoder: NSCoder) {super.init(coder: aDecoder)}
}

