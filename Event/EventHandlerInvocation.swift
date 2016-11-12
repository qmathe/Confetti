/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

public protocol AnyEventHandlerInvocation {
	func deliver(_ data: Any, from: AnyObject, to: AnyObject)
}


public struct EventHandlerInvocation<T, R>: AnyEventHandlerInvocation {

	public typealias EventHandlerFunction = @convention(swift) (R) -> (Event<T>) -> ()

	let function: EventHandlerFunction

	public init(function: @escaping EventHandlerFunction) {
		self.function = function
	}
	
	public func deliver(_ data: Any, from: AnyObject, to: AnyObject) {
		deliver(data as! T, from: from, to: to as! R)
}

	public func deliver(_ data: T, from: AnyObject, to: R) {
		let event = Event<T>(data: data, sender: from)
		
		function(to)(event)
	}
}
