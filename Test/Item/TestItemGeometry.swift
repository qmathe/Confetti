/**
	Copyright (C) 2017 Quentin Mathe

	Date:  July 2017
	License:  MIT
 */

import XCTest
import Tapestry
@testable import Confetti

class TestItemGeometry: XCTestCase {
    
    let objectGraph = ObjectGraph()
    lazy var ancestor: Item = {
        return Item(frame: Rect(x: 0, y: 0, width: 200, height: 200), objectGraph: objectGraph)
    }()
    lazy var parent: Item = {
        let parent = Item(frame: Rect(x: 10, y: 30, width: 200, height: 200), objectGraph: objectGraph)
        ancestor.items = [parent]
        return parent
    }()
    lazy var item: Item = {
        let item = Item(frame: Rect(x: 5, y: 2, width: 200, height: 200), objectGraph: objectGraph)
        parent.items = [item]
        return item
    }()
    
    // MARK: - Converting From/To Parent

    func testConvertRectToParent() {
        var newRect = item.convertToParent(Rect(x: 0, y: 0, width: 10, height: 20))

        XCTAssertEqual(5, newRect.origin.x)
        XCTAssertEqual(2, newRect.origin.y)

        newRect = item.convertToParent(Rect(x: 50, y: 100, width: 10, height: 20))
        
        XCTAssertEqual(55, newRect.origin.x)
        XCTAssertEqual(102, newRect.origin.y)

        item.origin = Point(x: 60, y: 80)
        newRect = item.convertToParent(Rect(x: -50, y: -100, width: 10, height: 20))

        XCTAssertEqual(10, newRect.origin.x)
        XCTAssertEqual(-20, newRect.origin.y)
        XCTAssertEqual(10, newRect.extent.width)
        XCTAssertEqual(20, newRect.extent.height)
    }
    
    func testConvertRectFromParent() {
        var newRect = item.convertFromParent(Rect(x: 0, y: 0, width: 10, height: 20))
    
        XCTAssertEqual(-5, newRect.origin.x)
        XCTAssertEqual(-2, newRect.origin.y)

        newRect = item.convertFromParent(Rect(x: 50, y: 100, width: 10, height: 20))

        XCTAssertEqual(45, newRect.origin.x)
        XCTAssertEqual(98, newRect.origin.y)

        item.origin = Point(x: 60, y: 80)
        newRect = item.convertFromParent(Rect(x: -50, y: -100, width: 10, height: 20))

        XCTAssertEqual(-110, newRect.origin.x)
        XCTAssertEqual(-180, newRect.origin.y)
        XCTAssertEqual(10, newRect.extent.width)
        XCTAssertEqual(20, newRect.extent.height)
    }
    
    // MARK: - Converting From/To Ancestor
    
    func testConvertRectFromIdenticalItem() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 20)
        XCTAssertEqual(rect, item.convert(rect, from: item))
    }

    func testConvertRectFromInvalidItem() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 20)
        XCTAssertNil(ancestor.convert(rect, from: item))
    }
    
    func testConvertRectFromItem() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 20)
        XCTAssertEqual(Rect(x: -5, y: -2, width: 0, height: 0), item.convert(Rect.zero, from: parent))
        XCTAssertEqual(Rect(x: -15, y: -32, width: 10, height: 20), item.convert(rect, from: ancestor))
    }

    func testConvertRectToIdenticalItem() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 20)
        XCTAssertEqual(rect, item.convert(rect, to: item))
    }
    
    func testConvertRectToInvalidItem() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 20)
        XCTAssertNil(ancestor.convert(rect, to: item))
    }
    
    func testConvertRectToItem() {
        let rect = Rect(x: 0, y: 0, width: 10, height: 20)
        XCTAssertEqual(Rect(x: 5, y: 2, width: 0, height: 0), item.convert(Rect.zero, to: parent))
        XCTAssertEqual(Rect(x: 15, y: 32, width: 10, height: 20), item.convert(rect, to: ancestor))
    }
}
