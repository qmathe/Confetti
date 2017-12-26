/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import XCTest
import RxSwift
import RxBlocking
import Tapestry
@testable import Confetti

class TestCollectionViewpoint: XCTestCase {

	var viewpoint = TestableCollectionViewpoint<String>(.just(["a", "b", "c"]))

	// MARK: - Generation

	func testGenerate() {
		XCTAssertEqual(3, viewpoint.item^.items?.count)
        XCTAssertTrue(viewpoint.selectionIndexes^.isEmpty)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet(0...2), viewpoint.changedIndexes^)
	}

	// MARK: - Insertion
	
	func testAdd() {
		viewpoint.add()
		
		XCTAssertEqual(4, viewpoint.item^.items?.count)
		XCTAssertEqual(IndexSet(integer: 3), viewpoint.selectionIndexes^)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet(0...3), viewpoint.changedIndexes^)
	}

	// MARK: - Removal
	
	func testRemoveForNoSelection() {
		assert(viewpoint.selectionIndexes^.isEmpty)
		viewpoint.remove()
	
		XCTAssertEqual(3, viewpoint.item^.items?.count)
        XCTAssertTrue(viewpoint.selectionIndexes^.isEmpty)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet(0...2), viewpoint.changedIndexes^)
	}

	func testRemoveForMultipleSelection() {
		viewpoint.selectionIndexes =^ IndexSet(1...2)
		viewpoint.remove()

		XCTAssertEqual(1, viewpoint.item^.items?.count)
		XCTAssertEqual(IndexSet(integer: 0), viewpoint.selectionIndexes^)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet(integer: 0), viewpoint.changedIndexes^)
	}
	
	func testRemoveForSingleSelection() {
        viewpoint.selectionIndexes =^ IndexSet(integer: 1)
		viewpoint.remove()
	
		XCTAssertEqual(2, viewpoint.item^.items?.count)
		XCTAssertEqual(IndexSet(integer: 0), viewpoint.selectionIndexes^)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet([0, 1]), viewpoint.changedIndexes^)
	}

	func testRemoveFirstForSingleSelection() {
		viewpoint.selectionIndexes =^ IndexSet(integer: 0)
		viewpoint.remove()

		XCTAssertEqual(IndexSet(integer: 0), viewpoint.selectionIndexes^)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet(0...1), viewpoint.changedIndexes^)
	}

	func testRemoveLastForSingleSelection() {
		viewpoint.selectionIndexes =^ IndexSet(integer: 2)
		viewpoint.remove()

		XCTAssertEqual(IndexSet(integer: 1), viewpoint.selectionIndexes^)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet(0...1), viewpoint.changedIndexes^)
	}

	func testRemoveAtForSingleSelection() {
		viewpoint.selectionIndexes =^ IndexSet(1...2)
		viewpoint.remove(at: 0)

		XCTAssertEqual(IndexSet(0...1), viewpoint.selectionIndexes^)
		XCTAssertTrue(viewpoint.changed^)
        XCTAssertEqual(IndexSet(0...1), viewpoint.changedIndexes^)
	}
    
    func testRemoveAllForSingleSelection() {
        viewpoint.selectionIndexes =^ IndexSet(integer: 2)
        viewpoint.remove()
        viewpoint.remove()
        viewpoint.remove()

        XCTAssertTrue(viewpoint.selectionIndexes^.isEmpty)
        XCTAssertTrue(viewpoint.changed^)
        XCTAssertTrue(viewpoint.changedIndexes^.isEmpty)
    }

	// MARK: - Removal and Insertion Combined
	
	func testRevertInsertion() {
		viewpoint.add()
		viewpoint.add()

		XCTAssertEqual(5, viewpoint.item^.items?.count)
		XCTAssertEqual(IndexSet(integer: 4), viewpoint.selectionIndexes^)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet(0...4), viewpoint.changedIndexes^)

		viewpoint.remove()
		viewpoint.remove()

		XCTAssertEqual(3, viewpoint.item^.items?.count)
		XCTAssertEqual(IndexSet(integer: 2), viewpoint.selectionIndexes^)
		XCTAssertTrue(viewpoint.changed^)
		XCTAssertEqual(IndexSet(0...2), viewpoint.changedIndexes^)
	}
}

class TestableCollectionViewpoint<T: CreatableElement>: CollectionViewpoint<T>, UI {

    override func generate(with collection: [T]) -> Item {
		return column(items: collection.map { self.label(extent: Extent(width: 100, height: 50), text: String(describing: $0)) })
	}
}

extension String: CreatableElement {

	public init() {
		self.init("x")
	}
}

postfix operator ^

public postfix func ^ <T>(observable: Observable<T>) -> T {
    return try! observable.toBlocking().first()!
}

public postfix func ^ <T>(observable: Observable<T>) -> Bool {
    return try! observable.toBlocking().first() != nil
}

public postfix func ^ <T>(observable: BehaviorSubject<T>) -> T {
    return try! observable.toBlocking().first()!
}
