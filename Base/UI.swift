/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation

public class UI {

	public var objectGraph: ObjectGraph
	
	public init(objectGraph: ObjectGraph) {
		self.objectGraph = objectGraph
	}
	
	public func item(frame frame: Rect, items: [Item] = []) -> Item {
		let item = Item(frame: frame, objectGraph: objectGraph)
	
		item.items = items
		
		return item
	}
}