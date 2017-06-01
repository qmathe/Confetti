/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  June 2017
	License:  MIT
 */

import Foundation

public struct Subscription<T>: Hashable {

	public typealias Action = (T) -> ()

	public let id = UUID()
	public let subscriber: AnyObject?
	public let action: Action
	public var hashValue: Int {
		return id.hashValue
	}
	
	init(subscriber: AnyObject?, action: @escaping Action) {
		self.subscriber = subscriber
		self.action = action
	}
}


public func == <T, U>(lhs: Subscription<T>, rhs: Subscription<U>) -> Bool {
    return lhs.id == rhs.id
}
