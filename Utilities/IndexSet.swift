/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  November 2017
	License:  Proprietary
 */

import Foundation

public extension IndexSet {

    public func inserting(_ integer: IndexSet.Element) -> IndexSet {
        var indexes = self
        indexes.insert(integer)
        return indexes
    }

    public func shifted(startingAt integer: IndexSet.Element, by delta: Int) -> IndexSet {
        var indexes = self
        indexes.shift(startingAt: integer, by: delta)
        return indexes
    }

    internal mutating func shift(startingAt integer: IndexSet.Element, by delta: Int, isEmpty: Bool) {
        shift(startingAt: integer, by: delta)
        if self.isEmpty && !isEmpty {
            self = IndexSet(integer: 0)
        }
    }

    internal func shifted(startingAt integer: IndexSet.Element, by delta: Int, isEmpty: Bool) -> IndexSet {
        var indexes = self
        indexes.shift(startingAt: integer, by: delta, isEmpty: isEmpty)
        return indexes
    }

    internal mutating func updateSubset(from oldIndexes: IndexSet, to newIndexes: IndexSet) {
        let unchangedIndexes = newIndexes.intersection(oldIndexes)
        formUnion(newIndexes.subtracting(unchangedIndexes))
    }

    internal func updatedSubset(from oldIndexes: IndexSet, to newIndexes: IndexSet) -> IndexSet {
        var indexes = self
        indexes.updateSubset(from: oldIndexes, to: newIndexes)
        return indexes
    }
}
