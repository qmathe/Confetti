//
//  ViewController.swift
//  UI Builder
//
//  Created by Quentin Mathé on 01/08/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Cocoa
import Confetti

class ViewController: NSViewController {

	var objectGraph = ObjectGraph()
	lazy var renderer: AppKitRenderer = { return AppKitRenderer(destination: self.view) }()

	override func viewDidLoad() {
		let ui = CustomUI(objectGraph: objectGraph)
		let button = ui.button(frame: Rect(x: 0, y: 0, width: 100, height: 20), text: "OK")
		let item = ui.item(frame: Rect(x: 0, y: 0, width: 1000, height: 200))

		button.render(renderer)
		item.render(renderer)
	}
}


class CustomUI: UI {

	func customUI() -> Item {
		return item(
			frame: Rect(x: 0, y: 0, width: 100, height: 20),
			items: [
				button(
					frame: Rect(x: 0, y: 0, width: 100, height: 20),
					 text: "OK"
				)
			])
	}
}

