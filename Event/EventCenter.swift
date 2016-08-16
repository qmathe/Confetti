/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

class EventCenter {

	var handlers = Set<AnyEventHandler>()
	
	/// Fires all the event handlers matching the arguments and returns them 
	/// in their invocation order.
	func send<T: AnyObject>(data: T, to: AnyObject, from: AnyObject) -> [EventHandler<T>] {
		
		return handlers.flatMap { $0 as? EventHandler<T> }
					   .filter { $0.receiver === to && ($0.sender === nil || $0.sender === from) }
		               .map { $0.send(data, from: from) }
	}
	
	func add(handler: EventHandlerType) {
		handlers.insert(handler as? AnyEventHandler ?? AnyEventHandler(handler: handler))
	}
	
	func remove(handler: EventHandlerType) {
		handlers.remove(handler as? AnyEventHandler ?? AnyEventHandler(handler: handler))
	}
}
