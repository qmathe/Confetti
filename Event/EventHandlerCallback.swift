/**
	Copyright (C) 2017 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  JUly 2017
	License:  MIT
 */

import Foundation

class EventHandlerCallback<T>: EventReceiver {

	typealias EventHandlerBlock = (Event<T>) -> ()

	private let block: EventHandlerBlock

	init(block: @escaping EventHandlerBlock) {
		self.block = block
	}
	
	deinit {
		print("Deinit \(self)")
	}
	
	func eventHandlerInvocationFor(_ selector: FunctionIdentifier) -> AnyEventHandlerInvocation? {
		precondition(selector == "")
		return EventHandlerInvocation { (callback: EventHandlerCallback<T>) in self.block }
	}
}
