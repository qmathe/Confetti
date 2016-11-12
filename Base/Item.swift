//
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation

private let _eventCenter = EventCenter()

public class Item: UIObject, Hashable, Geometry, RenderableNode, CustomStringConvertible {

	// MARK: Geometry

	public var transform = Matrix4()
	public var position: Position
	public var origin: Point
	public var pivot = Matrix4()

	// MARK: Item Identification

	public var identifier: String?
	
	// MARK: Aspects

	public var controller: Any?
	public var representedObject: Any?
	public var controlState: ControlState?

	public var mesh = Plane(size: Size(x: 0, y: 0, z: 0)) as Mesh
	/// Shorcut for mesh.materials.first.
	public var material: Material? { return mesh.materials.first }

	/// A style drawn on top of the background styles and any 2D descendant items.
	///
	/// A 2D item is an item whose mesh is a plane.
	public var foregroundStyle: Style?
	/// A style drawn behind the foreground style and any 2D descendant items.
	public var styles = [Style]()
	public var layout: Any?

	public var actionHandlers = [ActionHandler]()
	public var eventCenter: EventCenter { return _eventCenter }
	
	// MARK: Item Tree

	public var parent: Item?
	public var items: [Item]? {
		willSet {
			for item in items ?? [] { item.parent = nil }
		}
		didSet {
			for item in items ?? [] { item.parent = self }
		}
	}
	public var isGroup: Bool { return items != nil }
	public var isRoot: Bool { return parent == nil }
	public var isFrontmost: Bool { return parent?.items?.first == self }
	
	// MARK: Options

	public var hidden = false
	public var hashValue: Int {
		return Int()
	}
	
	// MARK: Initialization
	
	public init(frame: Rect, objectGraph: ObjectGraph) {
		self.origin = frame.origin
		self.mesh.size = Size(x: frame.extent.width, y: frame.extent.height, z: 0)
		self.position = Position(x: frame.extent.width / 2, y: frame.extent.height / 2, z: 0)
		super.init(objectGraph: objectGraph)
	}
    
    public var description: String {
        let description = "<\(self.dynamicType): \(unsafeAddressOf(self))>"
        
        guard let renderableAspect = styles.first as? RenderableAspect else {
            return description
        }
        return "\(description) - \(renderableAspect.dynamicType)"
    }
	
	// MARK: Renderer Integration

    /// You can call this method when implementing a custom Renderer.
    ///
    /// In other use cases, you must use Renderer.renderItem: to render an item tree.
	public func render(renderer: Renderer) -> RenderedNode {
		return (styles.first as? RenderableAspect)?.render(self, with: renderer) ?? renderer.renderView(self)
	}
}

public func == (lhs: Item, rhs: Item) -> Bool {
    return lhs === rhs
}


public struct ItemTreeGenerator: GeneratorType {

	public typealias Element = Item
	public var startItem: Item
	/// The items in tree enumerated from the start item with a preorder traversal.
	///
	/// The start item is included as the first item.
	public var descendantItems: [Item]
	private var generator: IndexingGenerator<[Item]>

	public init(item: Item) {
		startItem = item
		descendantItems = ItemTreeGenerator.descendantItemsFrom(item)
		generator = descendantItems.generate()
	}
	
	private static func descendantItemsFrom(item: Item) -> [Item] {
		var descendantItems = [item]
		
		for item in item.items ?? [] {
			descendantItems.append(item)
			descendantItems += descendantItemsFrom(item)
		}
		
		return descendantItems
	}

	public mutating func next() -> ItemTreeGenerator.Element? {
		return generator.next()
	}
}
