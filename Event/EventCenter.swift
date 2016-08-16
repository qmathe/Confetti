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
		
		return handlers.flatMap { $0 as? EventHandler<T> }
					   .filter { $0.receiver === to && ($0.sender === nil || $0.sender === from) }
		               .map { $0.send(data, from: from) }
	}
}
