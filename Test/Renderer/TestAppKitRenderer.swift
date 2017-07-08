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
		
		var buttonFrame = buttonItem.frame
		var subFrame = subitem.frame
		var sliderFrame = sliderItem.frame
		var otherButtonFrame = otherButtonItem.frame
		
		buttonFrame.origin = Point(x: 0, y: 0)
		subFrame.origin = Point(x: 0, y: 0)

		sliderFrame.extent.height = sliderView.frame.height
		sliderFrame.origin.y = sceneFrame.extent.height - sliderFrame.origin.y - sliderFrame.extent.height
		otherButtonFrame.extent.height = otherButtonView.frame.height
		otherButtonFrame.origin.y = sceneFrame.extent.height - otherButtonFrame.origin.y - otherButtonFrame.extent.height

        XCTAssertEqual(CGRectFromRect(buttonFrame), buttonView.frame)
        XCTAssertEqual(CGRectFromRect(subFrame), subview.frame)
		XCTAssertEqual(CGRectFromRect(sliderFrame), sliderView.frame)
		XCTAssertEqual(CGRectFromRect(otherButtonFrame), otherButtonView.frame)
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
		
		var buttonFrame = buttonItem.frame
		var sliderFrame = sliderItem.frame
		var otherButtonFrame = otherButtonItem.frame
		
		buttonFrame.extent.height = buttonView.frame.height
		buttonFrame.origin.y = sceneFrame.extent.height - buttonFrame.origin.y - buttonFrame.extent.height
		sliderFrame.extent.height = sliderView.frame.height
		sliderFrame.origin.y = sceneFrame.extent.height - sliderFrame.origin.y - sliderFrame.extent.height
		otherButtonFrame.extent.height = otherButtonView.frame.height
		otherButtonFrame.origin.y = sceneFrame.extent.height - otherButtonFrame.origin.y - otherButtonFrame.extent.height

        XCTAssertEqual(CGRectFromRect(sceneFrame), view.frame)
        XCTAssertEqual(CGRectFromRect(buttonFrame), buttonView.frame)
        XCTAssertEqual(CGRectFromRect(subitem.frame), subview.frame)
		XCTAssertEqual(CGRectFromRect(sliderFrame), sliderView.frame)
		XCTAssertEqual(CGRectFromRect(otherButtonFrame), otherButtonView.frame)
	}
}
