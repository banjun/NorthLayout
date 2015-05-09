//
//  ViewController.swift
//  NorthLayout
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//

import UIKit
import NorthLayout


class ViewController: UIViewController {
    override func loadView() {
        super.loadView()
        
        edgesForExtendedLayout = nil
        view.backgroundColor = UIColor.whiteColor()
        
        let nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.backgroundColor = UIColor.grayColor()
        
        let textLabel = UILabel()
        textLabel.text = "Some text label"
        textLabel.backgroundColor = UIColor.lightGrayColor()
        
        let autolayout = view.northLayoutFormat(["p": 8], [
            "name": nameLabel,
            "text": textLabel,
            ])
        autolayout("H:|-p-[name]-p-|")
        autolayout("H:|-p-[text]-p-|")
        autolayout("V:|-p-[name]-p-[text]")
    }
}

