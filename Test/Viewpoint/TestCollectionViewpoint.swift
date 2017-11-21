/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import XCTest
import Tapestry
@testable import Confetti

class TestCollectionViewpoint: XCTestCase {

	var viewpoint = TestableCollectionViewpoint<String>(["a", "b", "c"])

	// MARK: - Generation

	func testGenerate() {
		XCTAssertEqual(3, viewpoint.item.items?.count)
	}

	// MARK: - Insertion
	
	func testAdd() {
		viewpoint.add()
		
		XCTAssertEqual(4, viewpoint.item.items?.count)
		XCTAssertEqual(IndexSet(integer: 3), viewpoint.selectionIndexes)
	}

	// MARK: - Removal
	
	func testRemoveForNoSelection() {
		assert(viewpoint.selectionIndexes.isEmpty)
		viewpoint.remove()
	
		XCTAssertEqual(3, viewpoint.item.items?.count)
		XCTAssertTrue(viewpoint.selectionIndexes.isEmpty)
	}

	func testRemoveForMultipleSelection() {
		viewpoint.selectionIndexes = IndexSet([1, 2])
		viewpoint.remove()

		XCTAssertEqual(1, viewpoint.item.items?.count)
		XCTAssertEqual(IndexSet(integer: 0), viewpoint.selectionIndexes)
	}
	
	func testRemoveForSingleSelection() {
		viewpoint.selectionIndexes = IndexSet(integer: 1)
		viewpoint.remove()
	
		XCTAssertEqual(2, viewpoint.item.items?.count)
		XCTAssertEqual(IndexSet(integer: 0), viewpoint.selectionIndexes)
	}

	func testRemoveFirstForSingleSelection() {
		viewpoint.selectionIndexes = IndexSet(integer: 0)
		viewpoint.remove()

		XCTAssertEqual(IndexSet(integer: 0), viewpoint.selectionIndexes)
	}

	func testRemoveLastForSingleSelection() {
		viewpoint.selectionIndexes = IndexSet(integer: 2)
		viewpoint.remove()

		XCTAssertEqual(IndexSet(integer: 1), viewpoint.selectionIndexes)
	}

	func testRemoveAtForSingleSelection() {
		viewpoint.selectionIndexes = IndexSet([1, 2])
		viewpoint.remove(at: 0)

		XCTAssertEqual(IndexSet([0, 1]), viewpoint.selectionIndexes)
	}

	// MARK: - Removal and Insertion Combined
	
	func testRevertInsertion() {
		viewpoint.add()
		viewpoint.add()

		XCTAssertEqual(5, viewpoint.item.items?.count)
		XCTAssertEqual(IndexSet(integer: 4), viewpoint.selectionIndexes)

		viewpoint.remove()
		viewpoint.remove()

		XCTAssertEqual(3, viewpoint.item.items?.count)
		XCTAssertEqual(IndexSet(integer: 2), viewpoint.selectionIndexes)
	}
}

class TestableCollectionViewpoint<T: CreatableElement>: CollectionViewpoint<T>, UI {

	override init<S>(_ collection: S, objectGraph: ObjectGraph? = nil) where S : Sequence, S.Iterator.Element == T {
		super.init(collection, objectGraph: objectGraph)
	}

	override func generate() -> Item {
		return column(items: collection.map { self.label(extent: Extent(width: 100, height: 50), text: String(describing: $0)) })
	}
}

extension String: CreatableElement {

	public init() {
		self.init("x")
	}
}
