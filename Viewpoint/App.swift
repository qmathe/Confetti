/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation

protocol App {
	
	associatedtype 
	public init(value: T)

}

extension Viewpoint<T> {

	// MARK: - Initialization

	/// Initializes a new viewpoint to present the given value.
	public init(value: T) {
		self.value = value
		self.objectGraph = objectGraph
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
