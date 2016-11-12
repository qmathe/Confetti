//
//  TestConfetti.swift
//  TestConfetti
//
//  Created by Quentin Mathé on 09/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import XCTest
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
	
	func testItemTreeToViewHierarchy() {
		let rootNode = renderer.renderItem(item)
        let button = views[buttonItem]!
        let group = views[subitem]!

        // When the rendered destination is a view, this view may not be rooted in a window
		XCTAssertNotNil(button.superview)
	}
}


class TestAppKitToDefaultDestinationRenderer: TestAppKitRenderer {
	
	override func setUp() {
		destination = nil
		super.setUp()
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
}


class TestAppKitToViewDestinationRenderer: TestAppKitRenderer {
	
	override func setUp() {
		destination = NSView(frame: CGRectFromRect(sceneFrame))
		super.setUp()
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

}
