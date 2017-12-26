//
//  TestConfetti.swift
//  TestConfetti
//
//  Created by Quentin Mathé on 09/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import XCTest
import RxSwift
@testable import Tapestry
@testable import Confetti

class TestRenderer: XCTestCase {
	
	var destination: NSView!
	var rendererType: Renderer.Type!
	var renderer: Renderer!
	let sceneFrame = Rect(x: 0, y: 0, width: 1000, height: 400)
	let ui = TestUI(objectGraph: ObjectGraph())
	var item: Item!
	var buttonItem: Item!
	var subitem: Item!
	var sliderItem: Item!
	var otherButtonItem: Item!

	override func setUp() {
		super.setUp()
		
		renderer = rendererType.init(destination: destination)

		otherButtonItem = ui.button(frame: Rect(x: 0, y: 20, width: 400, height: 200), text: "Cancel", tap: { _, _ in })
        sliderItem = ui.slider(orientation: .horizontal, origin: Point(x: 100, y: 200), length: 200, max: 100, initial: 50, pan: { _, _ in })
		subitem = ui.item(frame: Rect(x: 400, y: 0, width: 600, height: 400), items: [sliderItem, otherButtonItem])

        buttonItem = ui.button(frame: Rect(x: 10, y: 10, width: 100, height: 20), text: "OK", tap: { _, _ in })

		item = ui.item(frame: sceneFrame, items: [buttonItem, subitem])
	}
}


class TestUI: UI {
    var objectGraph: ObjectGraph
    let bag = DisposeBag()
    
    required init(objectGraph: ObjectGraph) {
        self.objectGraph = objectGraph
    }
}
