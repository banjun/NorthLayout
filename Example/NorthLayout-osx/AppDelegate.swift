//
//  AppDelegate.swift
//  NorthLayout-osx
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//

import Cocoa
import NorthLayout


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Insert code here to initialize your application
        let view = window.contentView!
        
        let nameLabel = NSTextField()
        nameLabel.stringValue = "Name"
        nameLabel.backgroundColor = .gray
        
        let textLabel = NSTextField()
        textLabel.stringValue = "Some text label"
        textLabel.backgroundColor = .lightGray
        
        let autolayout = view.northLayoutFormat(["p": 8], [
            "name": nameLabel,
            "text": textLabel,
            "L": MinView(),
            "R": MinView(),
            ])
        autolayout("H:|-p-[name]-p-|")
        autolayout("H:|-p-[L][text(<=320)][R(==L)]-p-|")
        autolayout("V:|-p-[name]-p-[text]")
    }
}

