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

    func applicationDidFinishLaunching(_ notification: NSNotification) {
        // Insert code here to initialize your application
        let view = window.contentView!
        
        let nameLabel = NSTextField()
        nameLabel.stringValue = "Name"
        nameLabel.backgroundColor = .gray()
        
        let textLabel = NSTextField()
        textLabel.stringValue = "Some text label"
        textLabel.backgroundColor = .lightGray()
        
        let autolayout = view.northLayoutFormat(["p": 8], [
            "name": nameLabel,
            "text": textLabel,
            ])
        autolayout("H:|-p-[name]-p-|")
        autolayout("H:|-p-[text]-p-|")
        autolayout("V:|-p-[name]-p-[text]")
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

