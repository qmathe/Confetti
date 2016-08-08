//
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation

/// A collection of vertices defining a surface with associated materials or 
/// textures.
public protocol Mesh {
	var size: Size { get set }
	var materials: [Material] { get set }
}


public class Plane: Mesh {

	public var size: Size
	public var materials = [Material]()

	public init(size: Size) {
		self.size = size
	}
}
