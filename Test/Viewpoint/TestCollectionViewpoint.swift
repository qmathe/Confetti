/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import XCTest
import Tapestry
@testable import Confetti

class TestCollectionViewpoint: XCTestCase {

	var viewpoint = TestableCollectionViewpoint<Int>([0, 2, 4])

	func testGenerate() {
		XCTAssertEqual(3, viewpoint.item.items?.count)
	}
	
	func testAdd() {
		viewpoint.add()
		
		XCTAssertEqual(4, viewpoint.item.items?.count)
	}
	
	func testRemoveForNoSelection() {
		assert(viewpoint.selectionIndexes.isEmpty)
		viewpoint.remove()
	
		XCTAssertEqual(3, viewpoint.item.items?.count)
		XCTAssertTrue(viewpoint.selectionIndexes.isEmpty)
	}
	
	func testRemoveForSingleSelection() {
		viewpoint.selectionIndexes = IndexSet(integer: 2)
		viewpoint.remove()
	
		XCTAssertEqual(2, viewpoint.item.items?.count)
		XCTAssertTrue(viewpoint.selectionIndexes.isEmpty)
	}
	
	func testRemoveForMultipleSelection() {
		viewpoint.selectionIndexes = IndexSet([0, 2])
		viewpoint.remove()
	
		XCTAssertEqual(1, viewpoint.item.items?.count)
		XCTAssertTrue(viewpoint.selectionIndexes.isEmpty)
	}
	
	func testEnumerateReversedEmptiedSelection() {
		viewpoint.add()
		viewpoint.add()
		viewpoint.remove()
		viewpoint.remove()
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

extension Int: CreatableElement {

	public init() {
		self.init(integerLiteral: 1)
	}
}
