//
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation

class Item: Geometry {

	// MARK: Geometry

	var transform = Matrix4()
	var position: Position
	var origin: Point
	var pivot = Matrix4()

	// MARK: Item Identification

	var identifier: String?
	
	// MARK: Aspects

	var controller: Any?
	var representedObject: Any?
	var mesh = Plane(size: Size(x: 0, y: 0, z: 0)) as Mesh
	/// Shorcut for mesh.materials.first.
	var material: Material? { return mesh.materials.first }
	/// A style drawn on top of the background style and any 2D descendant items.
	///
	/// A 2D item is an item whose mesh is a plane.
	var foregroundStyle: Style?
	/// A style drawn behind the foreground style and any 2D descendant items.
	///
	/// Shorcut for mesh.materials.first.style when the first mesh materials 
	/// is a StyleMaterial, otherwise returns nil.
	var backgroundStyle: Style? { return (mesh.materials.first as? StyleMaterial)?.style }
	var layout: Any?
	
	// MARK: Item Tree

	var items: [Item]?
	var isGroup: Bool { return items != nil }
	
	// MARK: Options

	var hidden = false
	
	// MARK: Initialization
	
	init(frame: Rect) {
		self.origin = frame.origin
		self.mesh.size = Size(x: frame.extent.width, y: frame.extent.height, z: 0)
		self.position = Position(x: frame.extent.width / 2, y: frame.extent.height / 2, z: 0)
	}
}
