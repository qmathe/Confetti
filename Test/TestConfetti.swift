//
//  TestConfetti.swift
//  TestConfetti
//
//  Created by Quentin Mathé on 09/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import XCTest
@testable import Confetti

class TestAppKitRenderer: XCTestCase {
	
	let destination = NSView(frame: CGRectFromRect(Rect(x: 0, y: 0, width: 500, height: 400)))
	var renderer: AppKitRenderer!
	var item: Item!
	var buttonItem: Button!

	override func setUp() {
		super.setUp()
		
		renderer = AppKitRenderer(destination: destination)

		item = Item(frame: RectFromCGRect(destination.frame))
		buttonItem = Button(frame: Rect(x: 10, y: 10, width: 100, height: 20), text: "OK")

		item.items = [buttonItem]
	}

	func testViewInsertion() {
		let view = renderer.renderItem(item) as! NSView
		
		XCTAssertEqual(destination, view)
		XCTAssertEqual(item.frame, RectFromCGRect(view.frame))
		XCTAssertEqual(view, renderer.viewForItem(item))
		
		let buttonView = renderer.viewForItem(buttonItem)
		
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
		XCTAssertEqual(view, renderer.viewForItem(item))
		
		let buttonView = renderer.viewForItem(buttonItem)
		
		XCTAssertNil(buttonView)
		XCTAssertTrue(destination.subviews.isEmpty)
	}
}


extension AppKitRenderer {

	func viewForItem(item: Item) -> NSView? {
		return views[item]
	}
}