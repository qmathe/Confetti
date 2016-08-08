//
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation

public class Item: Hashable, Geometry, Rendered {

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
	public var mesh = Plane(size: Size(x: 0, y: 0, z: 0)) as Mesh
	/// Shorcut for mesh.materials.first.
	public var material: Material? { return mesh.materials.first }
	/// A style drawn on top of the background style and any 2D descendant items.
	///
	/// A 2D item is an item whose mesh is a plane.
	public var foregroundStyle: Style?
	/// A style drawn behind the foreground style and any 2D descendant items.
	///
	/// Shorcut for mesh.materials.first.style when the first mesh materials 
	/// is a StyleMaterial, otherwise returns nil.
	public var backgroundStyle: Style? { return (mesh.materials.first as? StyleMaterial)?.style }
	public var layout: Any?
	
	// MARK: Item Tree

	public var parent: Item?
	public var items: [Item]?
	public var isGroup: Bool { return items != nil }
	public var isRoot: Bool { return parent == nil }
	public var isFrontmost: Bool { return parent?.items?.first == self }
	
	// MARK: Options

	public var hidden = false
	public var hashValue: Int {
		return Int()
	}
	
	// MARK: Initialization
	
	public init(frame: Rect) {
		self.origin = frame.origin
		self.mesh.size = Size(x: frame.extent.width, y: frame.extent.height, z: 0)
		self.position = Position(x: frame.extent.width / 2, y: frame.extent.height / 2, z: 0)
	}
	
	// MARK: Renderer Integration

	public func render(renderer: Renderer) {
		renderer.renderItem(self)
	}
}

public func == (lhs: Item, rhs: Item) -> Bool {
    return lhs === rhs
}
