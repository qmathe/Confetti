
/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift
import RxCocoa

open class Viewpoint<T: Placeholder>: Presentation {

    // MARK: - Rx

    public let bag = DisposeBag()
    
    // MARK: - Content

    private let value = BehaviorRelay(value: T.placeholder)
    // The presented value.
    public var content: Observable<T> { return value.asObservable() }

    // MARK: - Presentation

    /// The presentation tree.
	open var presentations: [Presentation] { return [] }
	/// Whether the item representation or presented value have changed since the last UI update.
    public var changed = true
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
	///
	/// The object graph argument can be omitted only when the viewpoint is passed to `run(...)`.
    public init(_ value: Observable<T>, objectGraph: ObjectGraph? = nil) {
		self.objectGraph = objectGraph ?? ObjectGraph()

        value.subscribe(onNext: { [unowned self] value in
            self.value.accept(value)
            self.changed = true
        }).disposed(by: bag)
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
	open func generate() -> Item {
		fatalError("Must be overriden")
	}
}
