//
//  NorthLayoutTests.swift
//  NorthLayoutTests
//
//  Created by BAN Jun on 5/9/15.
//  Copyright (c) 2015 banjun. All rights reserved.
//

import UIKit
import XCTest
import NorthLayout

class NorthLayoutTests: XCTestCase {
    let rootView: UIView = {
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
        let v = UIView(frame: window.bounds)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        window.addSubview(v)
        return v
        }()
    
    func test() {
        let label = UILabel()
        label.text = "label"
        let field = UITextField()
        field.text = "text field"
        
        let p = CGFloat(16)
        let autolayout = rootView.northLayoutFormat(["p": p], [
            "label": label,
            "field": field,
            ])
        
        autolayout("H:|-p-[label]-p-[field]-p-|")
        autolayout("V:|-p-[label]")
        autolayout("V:|-p-[field]")
        
        rootView.layoutIfNeeded()
        
        XCTAssertEqual(label.frame.origin.x, p)
        XCTAssertEqual(field.frame.origin.x, label.frame.maxX + p)
        XCTAssertEqual(field.frame.maxX, rootView.frame.width - p)
        
        XCTAssertEqual(label.frame.origin.y, p)
        XCTAssertEqual(field.frame.origin.y, p)
    }
}
