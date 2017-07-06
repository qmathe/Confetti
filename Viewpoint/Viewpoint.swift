/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation

public protocol UIGenerator {
	var item: Item { get }
}

open class Viewpoint<T>: UIGenerator {

	/// The presented value.
    open var value: T
	/// Whether the item representation or presented value have changed since the last UI update.
    var changed = false
	/// The item representation.
	///
	/// The returned item tree is annotated with optimizations for `Renderer.render()`.
	public var item: Item {
		let item = generate()
		item.identifier = String(describing: self)
		item.changed = changed
		return item
	}

	// MARK: - Initialization

	/// Initializes a new viewpoint to present the given value.
	public init(value: T) {
		self.value = value
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
