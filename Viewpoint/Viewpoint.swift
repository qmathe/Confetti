
/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift

open class Viewpoint<T: Placeholder>: Presentation {

    // MARK: - Types

    public typealias State = T

    // MARK: - Rx

    public let bag = DisposeBag()
    
    // MARK: - Content

    // The presented value.
    public let value: Observable<T>
    public let operation = PublishSubject<Operation<T>>()

    // MARK: - Presentation

    /// The presentation tree.
	open var presentations: [Presentation] { return [] }
	/// Whether the item representation or presented value have changed since the last UI update.
    public var changed: Observable<Void> {
        return self.value.map { _ in Void() }
    }
	/// The item representation.
	///
	/// The returned item tree is annotated with optimizations for `Renderer.render()`.
	public var item: Observable<Item> {
        return changed.withLatestFrom(value).map { [unowned self] value in
            let item = self.generate(with: value)
            item.identifier = String(describing: self)
            item.changed = true
            return item
        }
	}

    public func clear() { }

	// MARK: - Initialization

	/// Initializes a new viewpoint to present the given value.
	///
	/// The object graph argument can be omitted only when the viewpoint is passed to `run(...)`.
    public init(_ value: Observable<T>, objectGraph: ObjectGraph? = nil) {
		self.objectGraph = objectGraph ?? ObjectGraph()
        self.value = value.update(using: operation)
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
    open func generate(with value: T) -> Item {
		fatalError("Must be overriden")
	}
}
