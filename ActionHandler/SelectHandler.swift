/**
	Copyright (C) 2017 Quentin Mathe

	Date:  November 2017
	License:  MIT
 */

import Foundation

open class SelectHandler: ActionHandler {
    
    private unowned var state: SelectionState
    
    init(objectGraph: ObjectGraph, state: SelectionState) {
        self.state = state
        super.init(objectGraph: objectGraph)
    }
    
    /// Computes selection indexes matching touches and updates selection with `select(at:,in:)`.
    ///
    /// By default, touches other than the first one are ignored.
    func select(with touches: [Touch], in item: Item) {
        guard let point = touches.first?.location(in: item),
              let touchedItem = item.item(at: point),
              let index = item.items?.index(of: touchedItem) else {
            return
        }
        select(at: IndexSet(integer: index), in: item)
    }

    /// Updates selection state and emits a `Select` event representing the new selection.
    ///
    /// Will be called when one or more elements in a row or column are tapped or targeted by a
    /// selection request. For example, when choosing _Select All_ in _Edit_ menu.
    func select(at indexes: IndexSet, in item: Item) {
        state.selectionIndexes = indexes
        item.eventCenter.send(Select(indexes), from: item)
    }
}
