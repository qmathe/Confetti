//
//  Item.swift
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation


protocol Geometry {

	/// The coordinate space transformation to obtain position, 
	/// orientation/rotation, and scale of an object from its parent coordinate
	/// space.
	///
	/// This is used to convert geometrical values from the parent coordinate 
	/// space to the object coordinate space. For converting geometry values 
	/// in the reverse direction, the invert matrix can be used.
	var transform: Matrix4 { get set }
	/// The center (x, y, z) of the object expressed in the world coordinate 
	/// space.
	///
	/// The position is derived from transform.
	var position: Position { get set }
	/// The top-left origin (x, y) of the object in the world coordinate space,
	/// but constrained to a Z plane passing through the center of the object
	/// and tracking the rotation of the object.
	///
	/// This is usually useless when working with 3D objects which aren't planes.
	///
	/// The origin is derived from position and size.
	var origin: Point { get set }
	/// The coordinate space transformation to obtain the anchor point used to
	/// manipulate the object and apply geometry changes.
	var pivot: Matrix4 { get set }
	/// The anchor point used to manipulate the object and apply geometry changes.
	///
	/// Can be used to position the pivot.
	///
	/// The anchor point is derived from position and pivot.
	var anchor: Position { get set }
	/// The dimensions (x, y, z) of the object expressed in the world coordinate 
	/// space.
	///
	/// The size is derived from the model.
	var size: Size { get set }
	var model: GeometryModel { get set }
}


extension Geometry {

	var size: Size {
		get { return model.size }
	}
	var anchorPoint: Position {
		get { return Position() }
		set { position = newValue }
	}
}
