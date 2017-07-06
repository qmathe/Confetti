/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation

public protocol Viewpoint {

    associatedtype T
    var value: T { get set }
    var changed: Bool { get }
	
	func generate() -> Item
}

public extension Viewpoint {

	public var item: Item {
		return generate()
	}
}
