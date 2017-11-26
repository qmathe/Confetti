//
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation
import Tapestry

private let _eventCenter = EventCenter()

open class Item: UIObject, Hashable, Geometry, RenderableNode, CustomStringConvertible {

	// MARK: Geometry

	open var transform = Matrix4()
	open var position: Position
	open var origin: Point
	open var pivot = Matrix4()

	// MARK: Item Identification

	open var identifier: String?
	
	// MARK: Aspects

	open var controller: Any?
	open var representedObject: Any?
	open var controlState: ControlState?

	open var mesh = Plane(size: Size(x: 0, y: 0, z: 0)) as Mesh
	/// Shorcut for mesh.materials.first.
	open var material: Material? { return mesh.materials.first }

	/// A style drawn on top of the background styles and any 2D descendant items.
	///
	/// A 2D item is an item whose mesh is a plane.
	open var foregroundStyle: Style?
	/// A style drawn behind the foreground style and any 2D descendant items.
	open var styles = [Style]()
	open var layout: Any?

	open var actionHandlers = [ActionHandler]()
	open var eventCenter: EventCenter { return _eventCenter }
	
	// MARK: Item Tree

	open var parent: Item?
	open var items: [Item]? {
		willSet {
			for item in items ?? [] { item.parent = nil }
		}
		didSet {
			for item in items ?? [] { item.parent = self }
		}
	}
	open var isGroup: Bool { return items != nil }
	open var isRoot: Bool { return parent == nil }
	open var isFrontmost: Bool { return parent?.items?.first == self }
    
    /// Returns the first item whose frame contains the given point expressed in the receiver
    /// coordinate space.
    public func item(at point: Point) -> Item? {
        return items?.first { $0.frame.contains(point) }
    }

    /// Returns a rect expressed in the receiver coordinate space equivalent to _rect_ parameter
    /// expressed in ancestor coordinate space.
    ///
    /// In case the receiver is not a descendant, returns nil.
    public func convert(_ rect: Rect, from ancestor: Item) -> Rect? {
        guard ancestor != self else {
            return rect
        }
        guard let parent = parent,
              let rectInParent = parent.convert(rect, from: ancestor) else {
            return nil
        }
        return convertFromParent(rectInParent)
    }

    /// Returns a rect expressed in ancestor coordinate space equivalent to _rect_ parameter
    /// expressed in the receiver coordinate space.
    ///
    /// In case the receiver is not a descendant, returns nil.
    public func convert(_ rect: Rect, to ancestor: Item) -> Rect? {
        guard ancestor != self else {
            return rect
        }
        guard let parent = parent else {
            return nil
        }
        return parent.convert(convertToParent(rect), to: ancestor)
    }
    
    /// Returns a point expressed in the receiver coordinate space equivalent to _point_ parameter
    /// expressed in ancestor coordinate space.
    ///
    /// In case the receiver is not a descendant, returns nil.
    public func convert(_ point: Point, from ancestor: Item) -> Point? {
        return convert(Rect(origin: point, extent: .zero), from: ancestor)?.origin
    }

    /// Returns a point expressed in ancestor coordinate space equivalent to _point_ parameter
    /// expressed in the receiver coordinate space.
    ///
    /// In case the receiver is not a descendant, returns nil.
    public func convert(_ point: Point, to ancestor: Item) -> Point? {
        return convert(Rect(origin: point, extent: .zero), to: ancestor)?.origin
    }

	// MARK: Options

	open var changed = false
	open var hidden = false
	open var hashValue: Int {
		return Int()
	}
	
	// MARK: Initialization
	
	public init(frame: Rect, objectGraph: ObjectGraph) {
		self.origin = frame.origin
		self.mesh.size = Size(x: frame.extent.width, y: frame.extent.height, z: 0)
		self.position = Position(x: frame.extent.width / 2, y: frame.extent.height / 2, z: 0)
		super.init(objectGraph: objectGraph)
	}
    
    open var description: String {
        let description = "<\(type(of: self)): \(Unmanaged.passUnretained(self).toOpaque())>"
        
        guard let renderableAspect = styles.first as? RenderableAspect else {
            return description
        }
        return "\(description) - \(type(of: renderableAspect))"
    }
	
	// MARK: Renderer Integration

    /// You can call this method when implementing a custom Renderer.
    ///
    /// In other use cases, you must use Renderer.renderItem: to render an item tree.
	open func render(_ renderer: Renderer) -> RenderedNode {
		return (styles.first as? RenderableAspect)?.render(self, with: renderer) ?? renderer.renderView(self)
	}
}

public func == (lhs: Item, rhs: Item) -> Bool {
    return lhs === rhs
}


public struct ItemTreeIterator: IteratorProtocol {

	public typealias Element = Item
	public var startItem: Item
	/// The items in tree enumerated from the start item with a preorder traversal.
	///
	/// The start item is included as the first item.
	public var descendantItems: [Item]
	fileprivate var generator: IndexingIterator<[Item]>

	public init(item: Item) {
		startItem = item
		descendantItems = ItemTreeIterator.descendantItemsFrom(item)
		generator = descendantItems.makeIterator()
	}
	
	fileprivate static func descendantItemsFrom(_ item: Item) -> [Item] {
		var descendantItems = [item]
		
		for item in item.items ?? [] {
			descendantItems.append(item)
			descendantItems += descendantItemsFrom(item)
		}
		
		return descendantItems
	}

	public mutating func next() -> ItemTreeIterator.Element? {
		return generator.next()
	}
}
