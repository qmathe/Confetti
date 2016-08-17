/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

/// Abstract type for AnyEventHandler and EventHandler
public protocol EventHandlerType {

	weak var receiver: AnyObject? { get }
	weak var sender: AnyObject? { get }
	var selector: FunctionIdentifier { get }
	var hashValue: Int { get }
}

/// Type-erased wrapper for EventHandler
///
/// This wrapper is required to store heterogenous EventHandler types in a set
/// as EventCenter.handlers does.
public struct AnyEventHandler: EventHandlerType, Hashable {

	public typealias EventType = AnyObject

	public weak var receiver: AnyObject? { return handler.receiver }
	public weak var sender: AnyObject? { return handler.sender }
	public var selector: FunctionIdentifier { return handler.selector }
	public var hashValue: Int { return handler.hashValue }
	let handler: EventHandlerType
	
	init(handler: EventHandlerType) {
		self.handler = handler
	}
}

public func == (lhs: AnyEventHandler, rhs: AnyEventHandler) -> Bool {
    return lhs.receiver === rhs.receiver && lhs.sender === rhs.sender && lhs.selector == rhs.selector
}
