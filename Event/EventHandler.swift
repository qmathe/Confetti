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
/// After deserializing a EventHandler, this allows to look up a function based 
/// on the handler function name.
///
/// This protocol works around the missing reflection support to call functions.
///
/// For now, must be implemented by classes that wants to receive events with 
/// methods as event handler functions.
public protocol EventReceiver: class {
	func eventHandlerFunctionFor(selector: FunctionIdentifier) -> ((receiver: AnyObject, event: Any) -> ())?
}

public struct EventHandler<T> : EventHandlerType, Hashable {
	/// The receiver is never nil.
	public private(set) weak  var receiver: AnyObject?
	public private(set) weak var sender: AnyObject?
	public let selector: FunctionIdentifier
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

	public init(selector: FunctionIdentifier, receiver: AnyObject, sender: AnyObject?) {
		self.selector = selector
		self.receiver = receiver
		self.sender = sender
	}

	public func send(data: T, from: AnyObject) -> EventHandler<T> {
		precondition(sender === nil || sender === from)

		let event = Event<T>(data: data, sender: from)

		guard let receiver = receiver as? EventReceiver else {
			fatalError("Event handlers must be unregistered when their receiver are deallocated.")
		}
		guard let closure = receiver.eventHandlerFunctionFor(selector) else {
			fatalError("Event handler function not declared for \(selector)")
		}
		closure(receiver: receiver, event: event as Any)

		return self
	}
}

public func == <T, U>(lhs: EventHandler<T>, rhs: EventHandler<U>) -> Bool {
    return lhs.receiver === rhs.receiver && lhs.sender === rhs.sender && lhs.selector == rhs.selector
}
