/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

public class EventCenter {

	public private(set) var handlers = Set<AnyEventHandler>()
	
	/// Fires all the event handlers matching the arguments and returns them 
	/// in their invocation order.
	public func send<T>(data: T, to: AnyObject? = nil, from: AnyObject) -> [EventHandlerType] {

		return handlers.filter { $0.handler.eventType == T.self }
					   .filter { ($0.receiver === to || to === nil) && ($0.sender === nil || $0.sender === from) }
		               .map { $0.send(data as Any, from: from) }
	}
	
	public func add(handler: EventHandlerType) {
		handlers.insert(handler as? AnyEventHandler ?? AnyEventHandler(handler: handler))
	}
	
	public func remove(handler: EventHandlerType) {
		handlers.remove(handler as? AnyEventHandler ?? AnyEventHandler(handler: handler))
	}
}
