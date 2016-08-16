/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

struct Event<T> {
	weak var sender: AnyObject?
	var data: T
	
	init(data: T, sender: AnyObject) {
		self.data = data
		self.sender = sender
	}
}
