/**
	Copyright (C) 2017 Quentin Mathe

	Date:  November 2017
	License:  MIT
 */

import Foundation
import RxSwift

public extension Observable where Element == [Touch] {
        
    /// Computes selection indexes from touches inside the given item, then combines it with
    /// current selection indexes, according to `Touch.modifiers`.
    ///
    /// Can be used when one or more elements in a row or column are tapped or targeted by a
    /// selection request. For example, when tapping the elements or choosing _Select All_ in _Edit_
    /// menu.
    ///
    /// By default, touches other than the first one are ignored.
    public func mapToIndexes(in item: Item, combinedWith oldIndexes: Observable<IndexSet>) -> Observable<IndexSet> {

        return withLatestFrom(oldIndexes) { ($0, $1) }.flatMap { (pair: ([Touch], IndexSet)) -> Observable<IndexSet> in
            let touches = pair.0
            let oldIndexes = pair.1

            guard let (newIndexes, modifiers) = self.select(with: touches, in: item) else {
                return .empty()
            }
            switch modifiers {
            case [.command]:
                return .just(oldIndexes.symmetricDifference(newIndexes))
            default:
                return .just(newIndexes)
            }
        }
    }

    public func mapToIndexes(in item: Item, combinedWithSelectionFrom state: SelectionState) -> Observable<IndexSet> {
        return mapToIndexes(in: item, combinedWith: state.selectionIndexes)
    }

    private func select(with touches: [Touch], in item: Item) -> (IndexSet, Modifiers)? {
        guard let touch = touches.first,
              let point = touch.location(in: item),
              let touchedItem = item.item(at: point),
              let index = item.items?.index(of: touchedItem) else {
            return nil
        }
        return (IndexSet(integer: index), touch.modifiers)
    }
}

