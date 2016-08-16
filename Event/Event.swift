/**
	Copyright (C) 2016 Quentin Mathe

	Author:  Quentin Mathe <quentin.mathe@gmail.com>
	Date:  August 2016
	License:  MIT
 */

import Foundation

public struct Event<T> {
	public private(set) weak var sender: AnyObject?
	public let data: T
	
	public init(data: T, sender: AnyObject) {
		self.data = data
		self.sender = sender
	}
}
