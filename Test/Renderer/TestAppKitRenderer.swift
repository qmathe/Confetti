//
//  TestConfetti.swift
//  TestConfetti
//
//  Created by Quentin Mathé on 09/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import XCTest
@testable import Confetti

class TestAppKitToViewDestinationRenderer: TestRenderer {
	
	override func setUp() {
		rendererType = AppKitRenderer.self as Renderer.Type!
		destination = NSView(frame: CGRectFromRect(sceneFrame))
		super.setUp()
	}
	
	var views: [Item: NSView] {
		return (renderer as! AppKitRenderer).views
	}

	func testViewInsertion() {
		let view = renderer.renderItem(item) as! NSView
		
		XCTAssertEqual(destination, view)
		XCTAssertEqual(item.frame, RectFromCGRect(view.frame))
		XCTAssertEqual(view, views[item])
		
		let buttonView = views[buttonItem]
		
		XCTAssertNotNil(buttonView)
		XCTAssertEqual(destination, buttonView?.superview)
		XCTAssertEqual(buttonItem.frame, RectFromCGRect(buttonView?.frame ?? CGRect.null))
	}
	
	func testViewRemoval() {
		renderer.renderItem(item) as! NSView

		item.items = []
		
		let view = renderer.renderItem(item) as! NSView
		
		XCTAssertEqual(destination, view)
		XCTAssertEqual(item.frame, RectFromCGRect(view.frame))
		XCTAssertEqual(view, views[item])
		
		let buttonView = views[buttonItem]
		
		XCTAssertNil(buttonView)
		XCTAssertTrue(destination.subviews.isEmpty)
	}

}
