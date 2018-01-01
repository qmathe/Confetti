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

public protocol CreatableCollectionState: CreatableState where T == [E] {
    associatedtype E: CreatableElement

    var collection: [E] { get }
    var changedIndexes: IndexSet { get }
    var selectionIndexes: IndexSet { get }

    init(collection: [E], changedIndexes: IndexSet, selectionIndexes: IndexSet)
}

public struct CollectionState<E: CreatableElement>: CreatableCollectionState {

    public typealias T = [E]

    public var value: [E] { return collection }
    public let collection: [E]
    public let changedIndexes: IndexSet
    public let selectionIndexes: IndexSet

    public init(collection: [E], changedIndexes: IndexSet, selectionIndexes: IndexSet) {
        self.collection = collection
        self.changedIndexes = changedIndexes
        self.selectionIndexes = selectionIndexes
    }

    public init() {
        self.init(collection: [], changedIndexes: IndexSet(), selectionIndexes: IndexSet())
    }

    public init(_ value: [E]) {
        self.init(collection: value,
                  changedIndexes: IndexSet(value.indices),
                  selectionIndexes: IndexSet())
    }

    public func replacing(with value: [E]) -> CollectionState<E> {
        // TODO: Constraint selection indexes to collection size
        return CollectionState(collection: value,
                               changedIndexes: IndexSet(value.indices),
                               selectionIndexes: selectionIndexes)
    }
}

open class CollectionViewpoint<State: CreatableCollectionState>: Presentation, SelectionState {

    // MARK: - Types

    public typealias E = State.E
    public typealias T = State.T

	public enum SelectionAdjustment {
		case none
		case previous
	}
    
    // MARK: - Rx

    public let bag = DisposeBag()
    
    // MARK: - Content

    /// The presented collection.
    public var collection: Observable<T> { return state.map { $0.value } }
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
	public init(_ collection: Observable<T>, objectGraph: ObjectGraph? = nil) {
		self.objectGraph = objectGraph ?? ObjectGraph()
        self.state = collection.update(using: operation)
        // Dummy subscription to cache the latest state, when emitting operations without any subscribers
        self.state.subscribe().disposed(by: bag)
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
    open func generate(with collection: T) -> Item {
		fatalError("Must be overriden")
	}
}
