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
	var mesh: Mesh

	// MARK: Item Identification

	var identifier: String?
	
	// MARK: Aspects

	var representedObject: Any
	// For 2D, there is style.backgroundStyles and style.foregroundStyles
	var style: Any
	var layout: Any
	
	// MARK: Item Tree

	var items: [Item]?
	var isGroup: Bool { return items != nil }
	
	// MARK: Options

	var hidden = false
}