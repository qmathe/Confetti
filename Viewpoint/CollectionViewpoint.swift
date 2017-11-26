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
    var selectionIndexes: IndexSet { get set }
}

open class CollectionViewpoint<T: CreatableElement>: Presentation, SelectionState {

	public enum SelectionAdjustment {
		case none
		case previous
	}

	open var presentations: [Presentation] { return [] }
	/// The presented collection.
    ///
    /// When a new collection is assigned, selection and changed indexes must be manually updated.
    /// Once a viewpoint has been created, assigning a new  collection should usually be avoided.
    open var collection: Array<T>
	public var changed = true
	/// The indexes corresponding to inserted and updated items since the last UI update.
	///
	/// Calling `remove()` or `remove(at:)` result in indexes being removed and successors shifted
    /// towards the first index.
	///
	/// These indexes are relative to `itemPresentingCollection(from:)`.
    var changedIndexes = IndexSet() {
		didSet {
			changed = true
		}
	}
	/// The item indexes visible based on the current expected extent.
	///
	/// These indexes and extent are relative to `itemPresentingCollection(from:)`.
	var visibleIndexes = IndexSet()
    public var selection: Observable<IndexSet> { return _selectionIndexes.asObservable() }
    private let _selectionIndexes = Variable<IndexSet>(IndexSet())
    public var selectionIndexes: IndexSet {
        get {
            return _selectionIndexes.value
        }
        set {
            let oldValue = _selectionIndexes.value
            _selectionIndexes.value = newValue
            let unchangedIndexes = newValue.intersection(oldValue)
            changedIndexes.formUnion(newValue.subtracting(unchangedIndexes))
        }
    }
    public var selectedElements: [T] { return collection[selectionIndexes] }
	open var selectionAdjustmentOnRemoval: SelectionAdjustment = .previous
	/// The item representation.
	///
	/// The returned item tree is annotated with optimizations for `Renderer.render()`.
	public var item: Item {
		let item = generate()
		let collectionItem = itemPresentingCollection(from: item)

		item.identifier = String(describing: self)
		for index in changedIndexes {
			collectionItem.items?[index].changed = true
		}

		return item
	}
	/// The object graph used to generate the item representation.
	///
	/// Can be ignored when you don't intent to persist or copy the generated item tree.
	public var objectGraph: ObjectGraph
	
	// MARK: - Initialization

	/// Initializes a new viewpoint to present the given collection.
	///
	/// The object graph argument can be omitted only when the viewpoint is passed to `run(...)`.
	public init<S>(_ collection: S, objectGraph: ObjectGraph? = nil) where S: Sequence, S.Iterator.Element == T {
		self.collection = Array(collection)
		self.changedIndexes = IndexSet(self.collection.indices)
		self.objectGraph = objectGraph ?? ObjectGraph()
	}
	
	// MARK: - Mutating Collection
	
	open func createElement() -> T {
		return T()
	}

    open func add() {
        collection.append(createElement())
		let index = Int(collection.count) - 1
		changedIndexes.insert(index)
		selectionIndexes = IndexSet(integer: index)
    }

    open func remove(at index: Int) {
        collection.remove(at: index)
		changedIndexes.shift(startingAt: index, by: -1)
		selectionIndexes.shift(startingAt: index, by: -1)
		if selectionIndexes.isEmpty && !collection.isEmpty {
			selectionIndexes = IndexSet(integer: 0)
		}
    }
	
	open func remove() {
		if selectionIndexes.isEmpty {
			print("Missing selection for remove action in /(self)")
		}
		// FIXME: IndexSet(selectionIndexes).reversed() crashes, see testEnumerateReverseEmptiedSelection()
		for index in Array(selectionIndexes).reversed() {
			remove(at: index)
		}
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
	
	/// Must be overriden to return a custom item tree.
	///
	/// By default, causes a fatal error.
	///
	/// You must never call this method directly.
	open func generate() -> Item {
		fatalError("Must be overriden")
	}
}
