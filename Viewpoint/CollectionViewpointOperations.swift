/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift
import Tapestry

extension CreatableCollectionState {

    fileprivate typealias State = Self

    // MARK: - Mutating State

    fileprivate func adding(_ element: E) -> State {
        let index = Int(collection.count)

        return State(collection: collection.appending(element),
                     changedIndexes: changedIndexes.inserting(index),
                     selectionIndexes: IndexSet(integer: index))
    }

    fileprivate func removing(at index: Int) -> State {
        let newCollection = collection.removing(at: index)
        let empty = newCollection.isEmpty

        return State(collection: newCollection,
                     changedIndexes: changedIndexes.shifted(startingAt: index, by: -1),
                     selectionIndexes: selectionIndexes.shifted(startingAt: index, by: -1, isEmpty: empty))
    }

    fileprivate func removing(context: Any) -> State {
        if selectionIndexes.isEmpty {
            print("Missing selection for remove action in /(context)")
        }

        var state = self
        // FIXME: IndexSet(selectionIndexes).reversed() crashes, see testEnumerateReverseEmptiedSelection()
        for index in Array(selectionIndexes).reversed() {
            state = state.removing(at: index)
        }
        return state
    }

    fileprivate func selecting(_ indexes: IndexSet) -> State {
        let adjustedChangedIndexes = changedIndexes.updatedSubset(from: selectionIndexes,
                                                                  to: indexes)
        return State(collection: collection,
                     changedIndexes: adjustedChangedIndexes,
                     selectionIndexes: indexes)
    }
}


public extension CollectionViewpoint {
	
	// MARK: - Mutating Collection
	
	public func createElement() -> E {
		return E()
	}

    public func add() {
        operation.onNext { [unowned self] in
            $0.adding(self.createElement())
        }
    }

    public func remove(at index: Int) {
        operation.onNext { $0.removing(at: index) }
    }
	
	public func remove() {
        operation.onNext { [unowned self] in
            $0.removing(context: self)
        }
	}

    public func select(_ indexes: IndexSet) {
        operation.onNext { $0.selecting(indexes) }
    }
}
