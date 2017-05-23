/**
	Copyright (C) 2017 Quentin Mathe

	Date:  January 2017
	License:  MIT
 */

import Foundation
import CoreGraphics

open class CoreGraphicsContext: Context2D {
    
    open var transform = Matrix4.identity()

    open func drawImage(image: Image, with blend: Blend, in rect: Rect) {
    
    }

    open func drawPath(path: BezierPath, with paint: Paint, in rect: Rect) {
    
    }

    open func drawText(text: AttributedString, with paint: Paint, in rect: Rect) {
    
    }
}
