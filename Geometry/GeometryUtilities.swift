//
//  Confetti
//
//  Created by Quentin Mathé on 02/06/2016.
//  Copyright © 2016 Quentin Mathé. All rights reserved.
//

import Foundation

typealias VectorFloat = CGFloat
typealias Matrix4 = CATransform3D

struct Vector3 {
	var x: VectorFloat, y: VectorFloat, z: VectorFloat
}

struct Vector2 {
	var x: VectorFloat, y: VectorFloat
}

typealias Position = Vector3
typealias Point = Vector2
typealias Size = Vector3
