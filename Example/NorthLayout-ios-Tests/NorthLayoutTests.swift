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
    let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
    lazy var rootView: UIView = {
        let v = UIView(frame: self.window.bounds)
        v.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.window.addSubview(v)
        return v
        }()

    override func setUp() {
        for sv in rootView.subviews {
            sv.removeFromSuperview()
        }
        window.frame = CGRect(x: 0, y: 0, width: 320, height: 480)
    }
    
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

    func testOnLabel() {
        let l = UILabel()
        let v = UIView()
        let autolayout = l.northLayoutFormat([:], ["v": v])
        autolayout("H:|[v]|")

        XCTAssertTrue(v.isDescendant(of: l))
        XCTAssertFalse(v.translatesAutoresizingMaskIntoConstraints)
    }

    func testMinView() {
        let l = UILabel()
        l.text = "label"

        let autolayout = rootView.northLayoutFormat([:], [
            "label": l,
            "L": MinView(),
            "R": MinView(),
            ])
        autolayout("H:|[L][label(<=320)][R(==L)]|")
        autolayout("V:|[label]|")

        window.frame = CGRect(x: 0, y: 0, width: 160, height: 480)
        rootView.layoutIfNeeded()
        XCTAssertEqual(l.frame.origin.x, 0)
        XCTAssertEqual(l.frame.width, 160)

        window.frame = CGRect(x: 0, y: 0, width: 640, height: 480)
        rootView.layoutIfNeeded()
        XCTAssertEqual(l.frame.origin.x, 160)
        XCTAssertEqual(l.frame.width, 320)
    }
}
