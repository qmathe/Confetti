
/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift

public protocol CreatableState {
    associatedtype T
    var value: T { get }
    init()
    init(_ value: T)
    func replacing(with value: T) -> Self
}

public struct State<T: Placeholder>: CreatableState {

    public let value: T

    // MARK: - Initialization

    public init() {
        self.value = T.placeholder
    }

    public init(_ value: T) {
        self.value = value
    }

    public func replacing(with value: T) -> State<T> {
        return State(value)
    }
}

open class Viewpoint<State: CreatableState>: Presentation {

    // MARK: - Types

    public typealias T = State.T

    // MARK: - Rx

    public let bag = DisposeBag()
    
    // MARK: - Content

    // The presented value.
    public var value: Observable<T> { return state.map { $0.value } }
    public let operation = PublishSubject<Operation<State>>()
    private let state: Observable<State>

    // MARK: - Presentation

    /// The presentation tree.
	open var presentations: [Presentation] { return [] }
	/// Whether the item representation or presented value have changed since the last UI update.
    public var changed: Observable<Void> {
        return self.state.map { _ in Void() }
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
        self.state = value.update(using: operation)
        // Dummy subscription to cache the latest state, when emitting operations without any subscribers
        self.state.subscribe().disposed(by: bag)
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
