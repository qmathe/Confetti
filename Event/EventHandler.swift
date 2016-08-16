/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

protocol AnyEventHandler {
	weak var receiver: AnyObject? { get }
	weak var sender: AnyObject? { get }
	func send(data: AnyObject, from: AnyObject) -> AnyEventHandler
	func accepts(data: AnyObject) -> Bool
}

struct EventHandler<T: AnyObject> : AnyEventHandler {
	weak var receiver: AnyObject?
	weak var sender: AnyObject?
	let selector: Selector

	init(selector: Selector, receiver: AnyObject, sender: AnyObject?) {
		self.selector = selector
		self.receiver = receiver
		self.sender = sender
	}

	func send(data: T, from: AnyObject) -> EventHandler<T> {
		precondition(sender === nil || sender === from)

		let event = Event<T>(data: data, sender: from)

		guard let receiver = receiver else {
			fatalError("Event handlers must be unregistered when their receiver are deallocated.")
		}
		receiver.performSelector(selector, withObject: event as! AnyObject)
		return self
	}

	func send(data: AnyObject, from: AnyObject) -> AnyEventHandler {
		return send(data as! T, from: from)
	}
	
	func accepts(data: AnyObject) -> Bool {
		return data is T
	}
}