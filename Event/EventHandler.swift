/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

struct EventHandler<T: AnyObject> : EventHandlerType, Hashable {
	weak var receiver: AnyObject?
	weak var sender: AnyObject?
	let selector: Selector
	var hashValue: Int {
		var hash = 17
		if let receiver = receiver {
			hash = 37 * hash + ObjectIdentifier(receiver).hashValue
		}
		if let sender = sender {
			hash = 37 * hash + ObjectIdentifier(sender).hashValue
		}
		hash = 37 * hash + selector.hashValue
		return hash
	}

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
}

func == <T, U>(lhs: EventHandler<T>, rhs: EventHandler<U>) -> Bool {
    return lhs.receiver === rhs.receiver && lhs.sender === rhs.sender && lhs.selector == rhs.selector
}
