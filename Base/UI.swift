/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation
import Tapestry

open class UI {

	open var objectGraph: ObjectGraph
	
	public init(objectGraph: ObjectGraph) {
		self.objectGraph = objectGraph
	}
	
	open func item(frame: Rect, items: [Item] = []) -> Item {
		let item = Item(frame: frame, objectGraph: objectGraph)
	
		item.items = items
		
		return item
	}
}
