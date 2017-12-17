/**
	Copyright (C) 2015 Quentin Mathe
 
	Date:  November 2015
	License:  Proprietary
 */

import Foundation

public extension Array {

    public subscript(indexes: IndexSet) -> [Element] {
        return indexes.rangeView.reduce([Element](), { $0 + self[$1] })
    }
    
    func  appending(_ element: Element) -> [Element] {
        var elements = self
        elements.append(element)
        return elements
    }
    
    func removing(at position: Int) -> [Element] {
        var elements = self
        elements.remove(at: position)
        return elements
    }
}
