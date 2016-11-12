/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

open class EventCenter {

	open fileprivate(set) var handlers = Set<AnyEventHandler>()
	
	/// Fires all the event handlers matching the arguments and returns them 
	/// in their invocation order.
	@discardableResult open func send<T>(_ data: T, to: AnyObject? = nil, from: AnyObject) -> [EventHandler<T>] {

		return handlers.flatMap { $0.handler as? EventHandler<T> }
					   .filter { ($0.receiver === to || to === nil) && ($0.sender === nil || $0.sender === from) }
		               .map { $0.send(data, from: from) }
	}
	
	open func add(_ handler: EventHandlerType) {
		handlers.insert(handler as? AnyEventHandler ?? AnyEventHandler(handler: handler))
	}
	
	open func remove(_ handler: EventHandlerType) {
		handlers.remove(handler as? AnyEventHandler ?? AnyEventHandler(handler: handler))
	}
}
