//
//  TestConfetti.swift
//  TestConfetti
//
//  Created by Quentin Mathé on 09/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import XCTest
@testable import Confetti

class TestRenderer: XCTestCase {
	
	var destination: NSView!
	var rendererType: Renderer.Type!
	var renderer: Renderer!
	let sceneFrame = Rect(x: 0, y: 0, width: 500, height: 400)
	var item: Item!
	var buttonItem: Button!

	override func setUp() {
		super.setUp()
		
		renderer = rendererType.init(destination: destination)

		item = Item(frame: sceneFrame)
		buttonItem = Button(frame: Rect(x: 10, y: 10, width: 100, height: 20), text: "OK")

		item.items = [buttonItem]
	}
}
