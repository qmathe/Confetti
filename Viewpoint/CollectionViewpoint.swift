/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import Foundation
import RxSwift
import RxCocoa
import Tapestry

public protocol CreatableElement {
	init()
}

public protocol SelectionState: class {
    var selectionIndexes: BehaviorRelay<IndexSet> { get }
}

open class CollectionViewpoint<T: CreatableElement>: Presentation, SelectionState {

    // MARK: - Types

	public enum SelectionAdjustment {
		case none
		case previous
	}
    
    // MARK: - Rx

    public let bag = DisposeBag()
    
    // MARK: - Content

    /// When a new collection is assigned, selection and changed indexes must be manually updated.
    private let collection = BehaviorRelay(value: [T]())
    /// The presented collection.
    public var content: Observable<[T]> { return collection.asObservable() }
    
    // MARK: - Presentation

    /// The presentation tree.
	open var presentations: [Presentation] { return [] }
    /// Whether the item representation or presented collection have changed since the last UI update.
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
    
    // MARK: - Visibility

	/// The item indexes visible based on the current expected extent.
	///
	/// These indexes and extent are relative to `itemPresentingCollection(from:)`.
	var visibleIndexes = IndexSet()
    
    // MARK: - Selection

    /// The selection as indexes relative to `content`.
    public let selectionIndexes = BehaviorRelay(value: IndexSet())
	open var selectionAdjustmentOnRemoval: SelectionAdjustment = .previous
	
	// MARK: - Initialization

	/// Initializes a new viewpoint to present the given collection.
	///
	/// The object graph argument can be omitted only when the viewpoint is passed to `run(...)`.
	public init(_ collection: Observable<[T]>, objectGraph: ObjectGraph? = nil) {
		self.objectGraph = objectGraph ?? ObjectGraph()
        
        collection.subscribe(onNext: { [unowned self] value in
            self.collection =^ value
            self.changedIndexes = IndexSet(value.indices)
        }).disposed(by: bag)

        selectionIndexes.update(IndexSet()).subscribe(onNext: { [unowned self] (oldIndexes, newIndexes) in
            self.changedIndexes.updateSubset(from: oldIndexes, to: newIndexes)
        }).disposed(by: bag)
	}
	
	// MARK: - Mutating Collection
	
	open func createElement() -> T {
		return T()
	}

    open func add() {
        collection =^ collection^.appending(createElement())
		let index = Int(collection^.count) - 1
		changedIndexes.insert(index)
		selectionIndexes =^ IndexSet(integer: index)
    }

    open func remove(at index: Int) {
        collection =^ collection^.removing(at: index)
		changedIndexes.shift(startingAt: index, by: -1)
        selectionIndexes =^ selectionIndexes^.shifted(startingAt: index, by: -1, isEmpty: collection^.isEmpty)
    }
	
	open func remove() {
		if selectionIndexes^.isEmpty {
			print("Missing selection for remove action in /(self)")
		}
		// FIXME: IndexSet(selectionIndexes).reversed() crashes, see testEnumerateReverseEmptiedSelection()
		for index in Array(selectionIndexes^).reversed() {
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
    
    /// The object graph used to generate the item representation.
    ///
    /// Can be ignored when you don't intent to persist or copy the generated item tree.
    public var objectGraph: ObjectGraph

    /// Returns a custom tree.
    ///
    /// You must never call this method directly.
    public func generate() -> Item {
        return generate(with: collection^)
    }
	
	/// Must be overriden to return a custom item tree.
	///
	/// By default, causes a fatal error.
	///
	/// You must never call this method directly.
    open func generate(with collection: [T]) -> Item {
		fatalError("Must be overriden")
	}
}
