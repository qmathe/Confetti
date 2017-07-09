/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import Tapestry

public protocol CreatableElement {
	init()
}

open class CollectionViewpoint<T: CreatableElement>: Presentation {

	/// The presented collection.
    open var collection: Array<T>
	var changed = true
	/// The item indexes changed since the last UI update.
	///
	/// These indexes are relative to `itemPresentingCollection(from:)`.
    var changedIndexes = IndexSet() {
		didSet {
			changed = !changedIndexes.isEmpty || changed
		}
	}
	/// The item indexes visible based on the current expected extent.
	///
	/// These indexes and extent are relative to `itemPresentingCollection(from:)`.
	var visibleIndexes = IndexSet()
	var selectionIndexes = IndexSet()
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
	public init<S>(collection: S, objectGraph: ObjectGraph? = nil) where S: Sequence, S.Iterator.Element == T {
		self.collection = Array(collection)
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
		if changedIndexes.contains(index) {
			changedIndexes.remove(index)
		}
		changedIndexes.shift(startingAt: IndexSet.Element(index), by: -1)
		if selectionIndexes.contains(index) {
			selectionIndexes.remove(index)
		}
		selectionIndexes.shift(startingAt: IndexSet.Element(index), by: -1)
    }
	
	open func remove() {
		for index in selectionIndexes {
			collection.remove(at: index)
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
	
	open func update() -> Presentation? {
		let presentation = changed ? self : nil
		changed = false
		return presentation
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
