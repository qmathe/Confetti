/**
	Copyright (C) 2017 Quentin Mathe

	Date:  January 2017
	License:  MIT
 */

import Foundation
import CoreGraphics

public typealias BezierPath = Any
public typealias AttributedString = Any

/// List of all supported drawing backends
public enum Backend {
    /// Default backend when creating a context with Context2D().
    case coreGraphics
}

/// Protocol implemented by all drawing contexts returned by Context2D()
public protocol Context2D {
    
    var transform: Matrix4 { get set }
    
    //func draw(in: Rect, blendMode: BlendMode, alpha: VectorFloat = 1.0) {
    func drawImage(image: Image, with blend: Blend, in rect: Rect)
    func drawPath(path: BezierPath, with paint: Paint, in rect: Rect)
    func drawText(text: AttributedString, with paint: Paint, in rect: Rect)
}

/// Creates a 2D drawing context based on the given backend.
public func CreateContext2D(with backend: Backend = .coreGraphics) -> Context2D {
    switch backend {
    case .coreGraphics:
        return CoreGraphicsContext()
    }
}
