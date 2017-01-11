/**
	Copyright (C) 2017 Quentin Mathe

	Date:  January 2017
	License:  MIT
 */

import Foundation
import CoreGraphics

/// List of all supported drawing backends
public enum Backend {
    /// Default backend when creating a context with 2DContext().
    case coreGraphics
}

/// Protocol implemented by all drawing contexts returned by 2DContext()
open protocol 2DContext {
    
    var transform: Matrix4
    
    //func draw(in: Rect, blendMode: BlendMode, alpha: VectorFloat = 1.0) {
    func drawImage(image: Image, with blend: Blend, in rect: Rect)
    func drawPath(path: BezierPath, with paint: Paint, in rect: Rect)
    func drawText(text: AttributedString, with paint: Paint, in rect: Rect)
}

/// Creates a 2D drawing context based on the given backend.
public func 2DContext(with backend: Backend = .coreGraphics) -> 2DContext {
    switch backend {
    case coreGraphics:
        return CoreGraphicsContext()
    }
}
