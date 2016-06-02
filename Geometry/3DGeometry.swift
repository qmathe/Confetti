//
//  3DGeometry.swift
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation

struct Geometry3D: Geometry {

	var transform = Matrix4()
	var position: Position
	var origin: Point
	var model: GeometryModel
	
	
	init(origin: Point, size: Size) {
		// TODO: precondition(size.depth == 0)
		
		self.origin = origin
		self.model = PlaneModel()
	}

}