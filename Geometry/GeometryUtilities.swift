//
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation

public typealias VectorFloat = CGFloat

/// Identical to CATransform3D
public struct Matrix4 {
    public var m11: CGFloat = 0, m12: CGFloat = 0, m13: CGFloat = 0, m14: CGFloat = 0
    public var m21: CGFloat = 0, m22: CGFloat = 0, m23: CGFloat = 0, m24: CGFloat = 0
    public var m31: CGFloat = 0, m32: CGFloat = 0, m33: CGFloat = 0, m34: CGFloat = 0
    public var m41: CGFloat = 0, m42: CGFloat = 0, m43: CGFloat = 0, m44: CGFloat = 0
	
	static func identity() -> Matrix4 {
		var matrix = Matrix4()

		matrix.m11 = 1
		matrix.m22 = 1
		matrix.m33 = 1
		matrix.m44 = 1

		return matrix
	}
    
    public init() { }
}

public struct Vector3 {
	public var x: VectorFloat, y: VectorFloat, z: VectorFloat
    
	public init(x: VectorFloat, y: VectorFloat, z: VectorFloat) {
		self.x = x
		self.y = y
        self.z = z
	}
}

public struct Vector2: Equatable {
	public var x: VectorFloat, y: VectorFloat

	public init(x: VectorFloat, y: VectorFloat) {
		self.x = x
		self.y = y
	}
}

public struct Extent: Equatable {
	public var width: VectorFloat, height: VectorFloat
    
    public init(width: VectorFloat, height: VectorFloat) {
		self.width = width
		self.height = height
	}
}

public struct Rect: Equatable {
	public var origin: Point, extent: Extent
	
	public init(origin: Point, extent: Extent) {
		self.origin = origin
		self.extent = extent
	}

	public init(x: VectorFloat, y: VectorFloat, width: VectorFloat, height: VectorFloat) {
		origin = Point(x: x, y: y)
		extent = Extent(width: width, height: height)
	}
}

public func == (lhs: Vector2, rhs: Vector2) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func == (lhs: Extent, rhs: Extent) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

public func == (lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.extent == rhs.extent
}

public typealias Position = Vector3
public typealias Point = Vector2
public typealias Size = Vector3

public enum Orientation {
	case vertical
	case horizontal
	case none
}
