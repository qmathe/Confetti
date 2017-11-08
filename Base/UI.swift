/**
	Copyright (C) 2016 Quentin Mathe

	Date:  August 2016
	License:  MIT
 */

import Foundation
import Tapestry
// FIXME: Remove this hack used to prevent linker errors with iOS target
import CoreGraphics

public protocol UI {
	var objectGraph: ObjectGraph { get set }
}


extension UI {
	
	public func item(frame: Rect, items: [Item] = []) -> Item {
		let item = Item(frame: frame, objectGraph: objectGraph)
		item.items = items
		return item
	}
	
	public func item(frame: Rect, items: Item...) -> Item {
		return item(frame: frame, items: items)
	}
    
    public func column(items: [Item]) -> Item {
        let maxWidth = items.map { $0.extent.width }.max() ?? 0
        let sumHeight = items.reduce(0) { sum, item in sum + item.extent.height }
        let column = item(frame: Rect(x: 0, y: 0, width: maxWidth, height: sumHeight), items: items)
        var position: VectorFloat = 0

        for item in items {
            item.origin = Point(x: 0, y: position)
            position += item.extent.height
        }
        return column
    }

	public func column(items: Item...) -> Item {
        return column(items: items)
    }

    public func row(items: [Item]) -> Item {
        let maxHeight = items.map { $0.extent.height }.max() ?? 0
        let sumWidth = items.reduce(0) { sum, item in sum + item.extent.width }
        let row = item(frame: Rect(x: 0, y: 0, width: sumWidth, height: maxHeight), items: items)
        var position: VectorFloat = 0

        for item in items {
            item.origin = Point(x: position, y: 0)
            position += item.extent.width
        }
        return row
    }
	
	public func row(items: Item...) -> Item {
        return row(items: items)
    }
}
