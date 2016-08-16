/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

class EventCenter {

	public var handlers = [AnyEventHandler]()
	
	func send<T: AnyObject>(data: T, to: AnyObject, from: AnyObject) -> [EventHandler<T>] {
		
		return handlers.filter { $0.receiver === to && ($0.sender === nil || $0.sender === from) && $0.accepts(data) }
		               .map { $0.send(data, from: from) as! EventHandler<T> }
	}
}

func sameType<T, U>(lhs: T, rhs: U) -> Bool {
    if let lhs = lhs as? U {
        return true
    }
	return false
}
