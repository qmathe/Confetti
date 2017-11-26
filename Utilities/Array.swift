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
}
