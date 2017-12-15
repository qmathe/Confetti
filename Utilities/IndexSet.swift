/**
	Copyright (C) 2017 Quentin Mathe
 
	Date:  November 2017
	License:  Proprietary
 */

import Foundation

public extension IndexSet {

    public mutating func shift(startingAt integer: IndexSet.Element, by delta: Int, isEmpty: Bool) {
        shift(startingAt: integer, by: delta)
        if self.isEmpty && !isEmpty {
            self = IndexSet(integer: 0)
        }
    }
}
