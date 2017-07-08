//
//  TestConfetti.swift
//  TestConfetti
//
//  Created by Quentin Mathé on 09/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import XCTest
import Tapestry
@testable import Confetti

class TestAppKitRenderer: TestRenderer {

	override func setUp() {
		rendererType = AppKitRenderer.self as Renderer.Type!
		super.setUp()
	}

	var views: [Item: NSView] {
		return (renderer as! AppKitRenderer).views
	}
	var windows: [Item: NSWindow] {
		return (renderer as! AppKitRenderer).windows
	}
}


class TestAppKitToDefaultDestinationRenderer: TestAppKitRenderer {
	
	override func setUp() {
		destination = nil
		super.setUp()
	}
    
	func testItemTreeToViewHierarchy() {
		let rootNode = renderer.renderItem(item) as! AppKitRootNode
        let buttonView = views[buttonItem]!
        let subview = views[subitem]!
        let sliderView = views[sliderItem]!
        let otherButtonView = views[otherButtonItem]!

        XCTAssertEqual(2, windows.count)
        XCTAssertEqual(4, views.count)
        XCTAssertEqual(windows[[buttonItem, subitem]] as! [NSWindow], rootNode.windows)
		XCTAssertEqual([buttonView, subview], windows.values.map { $0.contentView! })
        XCTAssertEqual([sliderView, otherButtonView], subview.subviews)
	}
	
	func testWindowInsertion() {
		let rootNode = renderer.renderItem(item) as! AppKitRootNode
		let window = rootNode.windows.first!

		XCTAssertEqual(2, rootNode.windows.count)
		XCTAssertNil(views[item])
		XCTAssertNil(windows[item])

		XCTAssertEqual(window.contentView, views[buttonItem])
		XCTAssertEqual(window, windows[buttonItem])
		XCTAssertEqual(buttonItem.frame, window.confettiFrame)
	}
	
	func testWindowRemoval() {
		let window = (renderer.renderItem(item) as! AppKitRootNode).windows.first!

		item.items = []
		
		let rootNode = renderer.renderItem(item) as! AppKitRootNode
		
		XCTAssertEqual(0, rootNode.windows.count)
		XCTAssertNil(views[item])
		XCTAssertNil(windows[item])

		XCTAssertNil(views[buttonItem])
		XCTAssertNil(windows[buttonItem])
		XCTAssertTrue((window.contentView?.subviews ?? []).isEmpty)
	}

	func testViewHierarchyGeometry() {
		let _ = renderer.renderItem(item)
        let buttonView = views[buttonItem]!
        let subview = views[subitem]!
        let sliderView = views[sliderItem]!
        let otherButtonView = views[otherButtonItem]!
		let sliderHeight = sliderView.frame.height

        XCTAssertEqual(CGRect(x: 0, y: 0, width: 100, height: 20), buttonView.frame)
        XCTAssertEqual(CGRect(x: 0, y: 0, width: 600, height: 400), subview.frame)
		XCTAssertEqual(CGRect(x: 100, y: 400 - 200 - sliderHeight, width: 200, height: sliderHeight), sliderView.frame)
		XCTAssertEqual(CGRect(x: 0, y: 400 - 20 - 200, width: 400, height: 200), otherButtonView.frame)
	}
}


class TestAppKitToViewDestinationRenderer: TestAppKitRenderer {
	
	override func setUp() {
		destination = NSView(frame: CGRectFromRect(sceneFrame))
		super.setUp()
	}

	func testItemTreeToViewHierarchy() {
		let view = renderer.renderItem(item) as! NSView
        let buttonView = views[buttonItem]!
        let subview = views[subitem]!
        let sliderView = views[sliderItem]!
        let otherButtonView = views[otherButtonItem]!

        XCTAssertEqual(0, windows.count)
        XCTAssertEqual(5, views.count)
		XCTAssertEqual([buttonView, subview], view.subviews)
        XCTAssertEqual([sliderView, otherButtonView], subview.subviews)
	}
	func testViewInsertion() {
		let view = renderer.renderItem(item) as! NSView
		
		XCTAssertEqual(destination, view)
		XCTAssertEqual(item.frame, view.confettiFrame)
		XCTAssertEqual(view, views[item])
		
		let buttonView = views[buttonItem]
		
		XCTAssertNotNil(buttonView)
		XCTAssertEqual(destination, buttonView?.superview)
		XCTAssertEqual(buttonItem.frame, buttonView?.confettiFrame ?? RectFromCGRect(CGRect.null))
	}
	
	func testViewRemoval() {
		let _ = renderer.renderItem(item) as! NSView

		item.items = []
		
		let view = renderer.renderItem(item) as! NSView
		
		XCTAssertEqual(destination, view)
		XCTAssertEqual(item.frame, view.confettiFrame)
		XCTAssertEqual(view, views[item])
		
		let buttonView = views[buttonItem]
		
		XCTAssertNil(buttonView)
		XCTAssertTrue(destination.subviews.isEmpty)
	}

	func testViewHierarchyGeometry() {
		let view = renderer.renderItem(item) as! NSView
        let buttonView = views[buttonItem]!
        let subview = views[subitem]!
        let sliderView = views[sliderItem]!
        let otherButtonView = views[otherButtonItem]!
		let sliderHeight = sliderView.frame.height

        XCTAssertEqual(CGRect(x: 0, y: 0, width: 1000, height: 400), view.frame)
        XCTAssertEqual(CGRect(x: 10, y: 400 - 10 - 20, width: 100, height: 20), buttonView.frame)
        XCTAssertEqual(CGRect(x: 400, y: 400 - 400, width: 600, height: 400), subview.frame)
		XCTAssertEqual(CGRect(x: 100, y: 400 - 200 - sliderHeight, width: 200, height: sliderHeight), sliderView.frame)
		XCTAssertEqual(CGRect(x: 0, y: 400 - 20 - 200, width: 400, height: 200), otherButtonView.frame)
	}
}
