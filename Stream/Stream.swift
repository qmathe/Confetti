/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  June 2017
	License:  MIT
 */

import Foundation

open class Stream<T>: Sequence {

	open private(set) var events = [T]()
	open private(set) var subscriptions = Set<Subscription<T>>()
	
	open func subscribe(_ subscriber: AnyObject? = nil, action: @escaping Subscription<T>.Action) -> Subscription<T> {
		let subscription = Subscription(subscriber: subscriber, action: action)
		subscriptions.insert(subscription)
		return subscription
	}
	
	open func unsubscribe(_ subscription: Subscription<T>) {
		subscriptions = Set(subscriptions.filter { $0 != subscription })
	}
	
	open func unsubscribe(_ subscriber: AnyObject) {
		subscriptions = Set(subscriptions.filter {
			guard let existingSubscriber = $0.subscriber else {
				return true
			}
			return ObjectIdentifier(existingSubscriber) != ObjectIdentifier(subscriber)
		})
	}
	
	public func makeIterator() -> StreamIterator<T> {
		return StreamIterator(self)
	}
}


public struct StreamIterator<T>: IteratorProtocol {

	public typealias Element = T
	private var iterator: IndexingIterator<Array<Element>>

	public init(_ stream: Stream<Element>) {
		self.iterator = stream.events.makeIterator()
	}

	public mutating func next() -> StreamIterator.Element? {
		return iterator.next()
	}
}
