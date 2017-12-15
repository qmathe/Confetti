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

    // MARK: - Types

	public enum SelectionAdjustment {
		case none
		case previous
	}
    
    // MARK: - Rx

    public let bag = DisposeBag()
    
    // MARK: - Content
    
    private let _collection = Variable([T]())
    /// The presented collection.
    ///
    /// When a new collection is assigned, selection and changed indexes must be manually updated.
    /// Once a viewpoint has been created, assigning a new  collection should usually be avoided.
    ///
    /// Using the setter should be restricted to subclasses.
    public var collection: [T] {
        get { return _collection.value }
        set { _collection.value = newValue }
    }
    // The presented collection as an observable.
    public var content: Observable<[T]> { return _collection.asObservable() }
    
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

    public var selection: Observable<IndexSet> { return _selectionIndexes.asObservable() }
    private let _selectionIndexes = Variable<IndexSet>(IndexSet())
    public var selectionIndexes: IndexSet {
        get {
            return _selectionIndexes.value
        }
        set {
            let oldValue = _selectionIndexes.value
            _selectionIndexes.value = newValue
            changedIndexes.updateSubset(from: oldValue, to: newValue)
        }
    }
	open var selectionAdjustmentOnRemoval: SelectionAdjustment = .previous
	
	// MARK: - Initialization

	/// Initializes a new viewpoint to present the given collection.
	///
	/// The object graph argument can be omitted only when the viewpoint is passed to `run(...)`.
	public init(_ collection: Observable<[T]>, objectGraph: ObjectGraph? = nil) {
		self.objectGraph = objectGraph ?? ObjectGraph()
        
        collection.subscribe(onNext: { [unowned self] value in
            self.collection = value
            self.changedIndexes = IndexSet(value.indices)
        }).disposed(by: bag)
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
        selectionIndexes.shift(startingAt: index, by: -1, isEmpty: collection.isEmpty)
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
