/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  June 2017
	License:  MIT
 */

import Foundation

open class Stream<T>: MutableCollection, RangeReplaceableCollection {

	public enum Event<T> {
		case value(T)
		case error(Error)
		case end
	}

	open private(set) var events = [Event<T>]()
	open private(set) var subscriptions = Set<Subscription<T>>()
	open private(set) var paused = false
	public let queue: DispatchQueue

	// MARK: - Collection Protocol

	public typealias Index = Int
	public var startIndex: Int { return events.startIndex }
	public var endIndex: Int { return events.endIndex }

    open subscript(i: Int) -> Event<T> {
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
	
	// MARK: - Initialization
	
	public required init() {
		queue = DispatchQueue.main
	}

	public required init(queue: DispatchQueue) {
		self.queue = queue
	}
	
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
	
	// MARK: - Posting Events
	
	open func append(_ newElement: Event<T>) {
		events.append(newElement)
		send()
	}
	
	open func append<S>(contentsOf newElements: S) where S : Sequence, S.Iterator.Element == Event<T> {
		events.append(contentsOf: newElements)
		send()
	}
	
	// MARK: - Sending Events
	
	open func send() {
		if paused {
			return
		}
		for subscription in subscriptions {
			for event in events {
				// FIXME: subscription.action(event)
			}
		}
		events.removeAll()
	}
	
	// MARK: - Controlling Sent Events
	
	open func pause() {
		paused = true
	}
	
	open func resume() {
		paused = false
		send()
	}
}

