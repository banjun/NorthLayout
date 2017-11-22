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
        
        XCTAssertEqual(label.frame.origin.y, p, accuracy: 1 / window.screen.scale)
        XCTAssertEqual(field.frame.origin.y, p, accuracy: 1 / window.screen.scale)
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

    func testLayoutMargins() {
        let content = UIView()
        let autolayout = rootView.northLayoutFormat([:], [
            "content": content])
        autolayout("H:||[content]||")
        autolayout("V:||[content]||")
        rootView.layoutIfNeeded()

        if #available(iOS 11, *) {
            XCTAssertEqual(content.frame.minX, rootView.safeAreaInsets.left + 8)
            XCTAssertEqual(content.frame.minY, rootView.safeAreaInsets.top + 8)
            XCTAssertEqual(content.frame.maxX, rootView.frame.width - rootView.safeAreaInsets.right - 8)
            XCTAssertEqual(content.frame.maxY, rootView.frame.height - rootView.safeAreaInsets.bottom - 8)
        } else {

        }
    }

    func testLayoutMarginsInInnerView() {
        let inner = MinView()
        let content = UIView()
        let innerLayout = inner.northLayoutFormat([:], ["content": content])
        innerLayout("H:||[content]||")
        innerLayout("V:||[content]||")

        let rootLayout = rootView.northLayoutFormat([:], ["inner": inner])
        rootLayout("H:|[inner(==100)]")
        rootLayout("V:|[inner(==100)]")

        rootView.layoutIfNeeded()

        // inner layout stick to top left corner
        XCTAssertEqual(inner.frame.minX, 0)
        XCTAssertEqual(inner.frame.minY, 0)
        XCTAssertEqual(inner.frame.maxX, 100)
        XCTAssertEqual(inner.frame.maxY, 100)

        if #available(iOS 11, *) {
            // innner content layout avoids safe area
            XCTAssertEqual(content.frame.minX, rootView.safeAreaInsets.left + 8)
            XCTAssertEqual(content.frame.minY, rootView.safeAreaInsets.top + 8)
            // assuming right bottom are not overlapping to safe area, stick to layout margins of inner
            XCTAssertEqual(content.frame.maxX, inner.frame.width - 8)
            XCTAssertEqual(content.frame.maxY, inner.frame.height - 8)
        } else {

        }
    }
}
