/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  July 2017
	License:  MIT
 */

import Tapestry

class ConfettiWindow: NSWindow {

	weak var renderer: AppKitRenderer?
	private var item: Item? {
		return renderer?.windows.first { $0.1 == self }?.0
	}

	override func sendEvent(_ event: NSEvent) {
		super.sendEvent(event)
	}
	
	// TODO: Move hit test logic to Tool

	func hit(for event: NSEvent) -> Item? {

		guard let item = item else {
			return nil
		}
		guard let contentView = contentView else {
			fatalError("Missing content view in \(self) for \(item)")
		}
		precondition(!contentView.isFlipped)

		let point = Point(point: contentView.convert(event.locationInWindow, from:  nil))
		let pointInItem = Point(x: point.x, y:contentView.frame.height - point.y)

		return hit(pointInItem, in: item, for: event)
	}
	
	private func hit(_ point: Point, in parent: Item, for event: NSEvent) -> Item? {
		for item in parent.items ?? [] {
			if item.frame.contains(point) {
				return item
			}
		}
		return nil
	}
}
