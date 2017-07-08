/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

public typealias FunctionIdentifier = String

/// Protocol to support EventHandler serialization in a UI builder.
///
/// After deserializing a EventHandler, this lets us look up a method based
/// on the handler function name.
///
/// This protocol works around the missing reflection support to call functions.
///
/// For now, must be implemented by classes that wants to receive events with 
/// methods as event handler functions.
public protocol EventReceiver: class {
	/// Returns a receiver method matching the selector name wrapped into an invocation.
	func eventHandlerInvocationFor(_ selector: FunctionIdentifier) -> AnyEventHandlerInvocation?
}

public struct EventHandler<T> : EventHandlerType, Hashable {

	// MARK: - Types

	private class Weak {
		weak var value: AnyObject?
		
		init(value: AnyObject?) {
			self.value = value
		}
	}
	
	// MARK: - Target and Action

	fileprivate(set) var _receiver: AnyObject?
	/// The receiver is never nil.
	public var receiver: AnyObject? { return (_receiver as? Weak)?.value ?? _receiver }
	public fileprivate(set) weak var sender: AnyObject?
	public let selector: FunctionIdentifier
	
	// MARK: - Hashable 

	public var hashValue: Int {
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
	
	// MARK: - Initialization

	public init(selector: FunctionIdentifier, receiver: AnyObject, sender: AnyObject?) {
		self.selector = selector
		self._receiver = Weak(value: receiver)
		self.sender = sender
	}
	
	public init(block: @escaping (Event<T>) -> (), sender: AnyObject?) {
		self._receiver = EventHandlerCallback(block: block)
		self.selector = ""
		self.sender = sender
	}
	
	// MARK: - Sending Events

	public func send(_ data: T, from: AnyObject) -> EventHandler<T> {
		precondition(sender === nil || sender === from)

		guard let receiver = receiver as? EventReceiver else {
			fatalError("Event handlers must be unregistered when their receiver are deallocated.")
		}
		guard let invocation = receiver.eventHandlerInvocationFor(selector) else {
			fatalError("Event handler function not declared for \(selector)")
		}
		invocation.deliver(data, from: from, to: receiver)

		return self
	}
}

public func == <T, U>(lhs: EventHandler<T>, rhs: EventHandler<U>) -> Bool {
    return lhs.receiver === rhs.receiver && lhs.sender === rhs.sender && lhs.selector == rhs.selector
}
