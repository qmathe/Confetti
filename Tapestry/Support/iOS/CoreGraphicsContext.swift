/**
	Copyright (C) 2017 Quentin Mathe

	Date:  January 2017
	License:  MIT
 */

import Foundation
import CoreGraphics

open class CoreGraphicsContext: 2DContext {
    
    var transform: Matrix4
    
    func drawImage(image: Image, with blend: Blend, in rect: Rect) {
    
    }

    func drawPath(path: BezierPath, with paint: Paint, in rect: Rect) {
    
    }

    func drawText(text: AttributedString, with paint: Paint, in rect: Rect) {
    
    }
}
