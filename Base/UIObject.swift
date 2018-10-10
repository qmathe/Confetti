/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

open class ObjectGraph {

	public init() { }
}


open class UIObject {

	public let objectGraph: ObjectGraph
	
	public init(objectGraph: ObjectGraph) {
		self.objectGraph = objectGraph
	}
}
