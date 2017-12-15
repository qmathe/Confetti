/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  November 2017
	License:  Proprietary
 */

import Foundation

public extension IndexSet {

    internal mutating func shift(startingAt integer: IndexSet.Element, by delta: Int, isEmpty: Bool) {
        shift(startingAt: integer, by: delta)
        if self.isEmpty && !isEmpty {
            self = IndexSet(integer: 0)
        }
    }
    
    internal mutating func updateSubset(from oldIndexes: IndexSet, to newIndexes: IndexSet) {
        let unchangedIndexes = newIndexes.intersection(oldIndexes)
        formUnion(newIndexes.subtracting(unchangedIndexes))
    }
}
