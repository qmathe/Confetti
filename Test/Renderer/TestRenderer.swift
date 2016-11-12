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
	let sceneFrame = Rect(x: 0, y: 0, width: 1000, height: 400)
	let ui = UI(objectGraph: ObjectGraph())
	var item: Item!
	var buttonItem: Item!
	var subitem: Item!
	var sliderItem: Item!
	var otherButtonItem: Item!

	override func setUp() {
		super.setUp()
		
		renderer = rendererType.init(destination: destination)

		otherButtonItem = ui.button(frame: Rect(x: 0, y: 0, width: 400, height: 200), text: "Cancel")
		sliderItem = ui.slider(orientation: .Horizontal, origin: Point(x: 100, y: 200), length: 200, max: 100, initial: 50)
		subitem = ui.item(frame: Rect(x: 400, y: 0, width: 600, height: 400), items: [sliderItem, otherButtonItem])

		buttonItem = ui.button(frame: Rect(x: 10, y: 10, width: 100, height: 20), text: "OK")

		item = ui.item(frame: sceneFrame, items: [buttonItem, subitem])
	}
}
