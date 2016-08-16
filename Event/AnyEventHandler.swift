/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

/// Abstract type for AnyEventHandler and EventHandler
protocol EventHandlerType {
	weak var receiver: AnyObject? { get }
	weak var sender: AnyObject? { get }
	var selector: Selector { get }
	var hashValue: Int { get }
}

/// Type-erased wrapper for EventHandler
///
/// This wrapper is required to store heterogenous EventHandler types in a set
/// as EventCenter.handlers does.
struct AnyEventHandler: EventHandlerType, Hashable {
	weak var receiver: AnyObject? { return handler.receiver }
	weak var sender: AnyObject? { return handler.sender }
	var selector: Selector { return handler.selector }
	var hashValue: Int { return handler.hashValue }
	let handler: EventHandlerType
	
	init(handler: EventHandlerType) {
		self.handler = handler
	}
	
	func send<T: AnyObject>(data: T, from: AnyObject) -> EventHandler<T> {
		return (handler as! EventHandler<T>).send(data, from: from)
	}
}

func == (lhs: AnyEventHandler, rhs: AnyEventHandler) -> Bool {
    return lhs.receiver === rhs.receiver && lhs.sender === rhs.sender && lhs.selector == rhs.selector
}
