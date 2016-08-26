/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public class ObjectGraph {

	public init() { }
}


public class UIObject {

	public let objectGraph: ObjectGraph
	
	public init(objectGraph: ObjectGraph) {
		self.objectGraph = objectGraph
	}
}
