/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  June 2017
	License:  MIT
 */

import Foundation

open class Stream<T>: MutableCollection, RangeReplaceableCollection {

	open private(set) var events = [T]()
	open private(set) var subscriptions = Set<Subscription<T>>()

	// MARK: - Collection Protocol

	public typealias Index = Int
	public var startIndex: Int { return events.startIndex }
	public var endIndex: Int { return events.endIndex }

    open subscript(i: Int) -> T {
		get {
			return events[i]
		}
		set {
			events[i] = newValue
		}
    }
	
	public func index(after i: Int) -> Int {
		return events.index(after: i)
	}
	
	public func replaceSubrange<C>(_ subrange: Range<Int>, with newElements: C) where C: Collection, C.Iterator.Element == Stream.Iterator.Element  {
		events.replaceSubrange(subrange, with: newElements)
	}

	public required init() { }
	
	// MARK: - Subcribing to Events
	
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

	// MARK: - Sequence Protocol

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
