/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

/// This code is copied/pasted from https://www.mikeash.com/pyblog/friday-qa-2015-12-25-swifty-targetaction.html
class ActionTrampoline<T>: NSObject {
	var action: T -> Void

	init(action: T -> Void) {
		self.action = action
	}

	@objc func action(sender: NSControl) {
		action(sender as! T)
	}
}


let NSControlActionFunctionProtocolAssociatedObjectKey = UnsafeMutablePointer<Int8>.alloc(1)

protocol NSControlActionFunctionProtocol { }

extension NSControlActionFunctionProtocol where Self: NSControl {

	func setAction(action: Self -> Void) {
		let trampoline = ActionTrampoline(action: action)
		self.target = trampoline
		self.action = "action:"
		objc_setAssociatedObject(self, NSControlActionFunctionProtocolAssociatedObjectKey, trampoline, .OBJC_ASSOCIATION_RETAIN)
	}
}

extension NSControl: NSControlActionFunctionProtocol { }
