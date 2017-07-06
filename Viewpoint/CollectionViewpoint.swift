/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import Tapestry

open class CollectionViewpoint<T>: ViewpointProtocol {

	/// The presented collection.
    open var collection: AnyCollection<T>
	/// The item indexes changed since the last UI update.
	///
	/// These indexes are relative to `itemPresentingCollection(from:)`.
    var changedIndexes = IndexSet()
	/// The item indexes visible based on the current expected extent.
	///
	/// These indexes and extent are relative to `itemPresentingCollection(from:)`.
	var visibleIndexes = IndexSet()
	/// The item representation.
	///
	/// The returned item tree is annotated with optimizations for `Renderer.render()`.
	public var item: Item {
		let item = generate()
		let collectionItem = itemPresentingCollection(from: item)

		item.identifier = String(describing: self)
		for index in changedIndexes {
			item.items?[index].changed = true
		}

		return item
	}
	
	// MARK: - Initialization
	
	/// Initializes a new viewpoint to present the given collection.
	public init(collection: AnyCollection<T>) {
		self.collection = collection
	}
	
	// MARK: - Tracking Changes and Visibility
	
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
