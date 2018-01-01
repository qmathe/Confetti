/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift
import Tapestry

public protocol CreatableElement {
	init()
}

public protocol SelectionState: class {
    var selectionIndexes: Observable<IndexSet> { get }
}

open class CollectionViewpoint<T: CreatableElement>: Presentation, SelectionState {

    // MARK: - Types

    public struct State {
        public let collection: [T]
        public let changedIndexes: IndexSet
        public let selectionIndexes: IndexSet

        // MARK: - Mutating State

        fileprivate func adding(_ element: T) -> State {
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

	public enum SelectionAdjustment {
		case none
		case previous
	}
    
    // MARK: - Rx

    public let bag = DisposeBag()
    
    // MARK: - Content

    /// The presented collection.
    public var collection: Observable<[T]> { return state.map { $0.collection } }
    public let operation = PublishSubject<Operation<State>>()
    private let state: Observable<State>
    
    // MARK: - Presentation

    /// The presentation tree.
	open var presentations: [Presentation] { return [] }
    /// Whether the item representation or presented collection have changed since the last UI update.
    public var changed: Observable<Void> {
        return changedIndexes.map { _ in Void () }
    }
	/// The indexes corresponding to inserted and updated items since the last UI update.
	///
	/// Calling `remove()` or `remove(at:)` result in indexes being removed and successors shifted
    /// towards the first index.
	///
	/// These indexes are relative to `itemPresentingCollection(from:)`.
    var changedIndexes: Observable<IndexSet> { return state.map { $0.changedIndexes } }
    /// The item representation.
    ///
    /// The returned item tree is annotated with optimizations for `Renderer.render()`.
    public var item: Observable<Item> {
        return changedIndexes.withLatestFrom(collection) { ($0, $1) }.map { [unowned self] in
            let changedIndexes = $0.0
            let collection = $0.1
            let item = self.generate(with: collection)
            let collectionItem = self.itemPresentingCollection(from: item)

            item.identifier = String(describing: self)
            for index in changedIndexes {
                collectionItem.items?[index].changed = true
            }

            return item
        }
    }

    public func clear() {
        // FIXME: changedIndexes.onNext(IndexSet())
    }
    
    // MARK: - Visibility

	/// The item indexes visible based on the current expected extent.
	///
	/// These indexes and extent are relative to `itemPresentingCollection(from:)`.
	var visibleIndexes = IndexSet()
    
    // MARK: - Selection

    /// The selection as indexes relative to `content`.
    public var selectionIndexes: Observable<IndexSet> { return state.map { $0.selectionIndexes } }
	open var selectionAdjustmentOnRemoval: SelectionAdjustment = .previous
	
	// MARK: - Initialization

	/// Initializes a new viewpoint to present the given collection.
	///
	/// The object graph argument can be omitted only when the viewpoint is passed to `run(...)`.
	public init(_ collection: Observable<[T]>, objectGraph: ObjectGraph? = nil) {
        let initialState = State(collection: [], changedIndexes: IndexSet(), selectionIndexes: IndexSet())
        let state = collection.map {
            State(collection: $0, changedIndexes: IndexSet($0.indices), selectionIndexes: IndexSet())
        }
        let sourceUpdate = state.map { newState -> Operation<State>  in
            return { oldState in
                // TODO: Constraint selection indexes to collection size
                return State(collection: newState.collection,
                             changedIndexes: newState.changedIndexes,
                             selectionIndexes: oldState.selectionIndexes)
            }
        }

		self.objectGraph = objectGraph ?? ObjectGraph()
        self.state = Observable<Operation<State>>.merge(operation, sourceUpdate).scan(initialState) { oldState, operation in
                let newState = operation(oldState)
                print("New state \(newState)")
                return newState
            }
            .share(replay: 1, scope: .forever)
        // Dummy subscription to cache the latest state, when emitting operations without any subscribers
        self.state.subscribe().disposed(by: bag)
	}
	
	// MARK: - Mutating Collection
	
	open func createElement() -> T {
		return T()
	}

    open func add() {
        operation.onNext { [unowned self] in
            $0.adding(self.createElement())
        }
    }

    open func remove(at index: Int) {
        operation.onNext { $0.removing(at: index) }
    }
	
	open func remove() {
        operation.onNext { [unowned self] in
            $0.removing(context: self)
        }
	}

    open func select(_ indexes: IndexSet) {
        operation.onNext { $0.selecting(indexes) }
    }
	
	// MARK: - Handling Changes and Visibility
	
	/// Returns the item presenting the viewpoint model.
	///
	/// The returned item children represents the collection elements.
	///
	/// By default, returns the item passed in argument which usually corresponds to 
	/// `CollectionViewPoint.item`.
	///
	/// Can be overriden but it is rarely needed.
	open func itemPresentingCollection(from item: Item) -> Item {
		return item
	}
	
	// MARK: - Generating Item Representation
    
    /// The object graph used to generate the item representation.
    ///
    /// Can be ignored when you don't intent to persist or copy the generated item tree.
    public var objectGraph: ObjectGraph
	
	/// Must be overriden to return a custom item tree.
	///
	/// By default, causes a fatal error.
	///
	/// You must never call this method directly.
    open func generate(with collection: [T]) -> Item {
		fatalError("Must be overriden")
	}
}
